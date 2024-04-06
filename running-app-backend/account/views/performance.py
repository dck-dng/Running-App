from rest_framework import viewsets, \
                            mixins, \
                            response, \
                            status

from account.models import Performance

from account.serializers import PerformanceSerializer, \
                                CreatePerformanceSerializer, \
                                LeaderboardSerializer

from rest_framework.decorators import action
from functools import cmp_to_key

class PerformanceViewSet(
    mixins.CreateModelMixin,
    mixins.ListModelMixin,
    mixins.RetrieveModelMixin,
    viewsets.GenericViewSet
):
    queryset = Performance.objects.all()
    serializer_class = PerformanceSerializer
    
    def get_queryset(self):
        queryset = super().get_queryset()
        if self.action == 'leaderboard':
            gender = self.request.query_params.get('gender', None)
            start_date = self.request.query_params.get('start_date', None)
            end_date = self.request.query_params.get('end_date', None)

            if gender: 
                queryset = queryset.filter(user__profile__gender=gender)

            if start_date and end_date:
                queryset = sorted(queryset, key=lambda x: (
                    -x.range_stats(start_date, end_date, sport_type="RUNNING")[0], 
                    -x.range_stats(start_date, end_date, sport_type="RUNNING")[3]))
    
        return queryset

    def get_serializer_class(self):
        if self.action == "create":
            return CreatePerformanceSerializer
        elif self.action == 'leaderboard': 
            return LeaderboardSerializer
        return super().get_serializer_class()
    
    @action(detail=False, methods=['GET'], url_path='leaderboard', name='leaderboard')
    def leaderboard(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        start_date = self.request.query_params.get('start_date', None)
        end_date = self.request.query_params.get('end_date', None)
        serializer = self.get_serializer(queryset, many=True, context={'start_date': start_date, 'end_date': end_date})
        return response.Response(serializer.data, status=status.HTTP_200_OK)
    
    # def get_serializer(self, *args, **kwargs):
    #     serializer_class = self.get_serializer_class()
    #     kwargs["context"] = self.get_serializer_context()
    #     return serializer_class(*args, **kwargs)
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        sport_type = self.request.query_params.get('sport_type', None)
        start_date = self.request.query_params.get('start_date', None)
        end_date = self.request.query_params.get('end_date', None)
        period = self.request.query_params.get('period', None)
        
        serializer = self.get_serializer(
            instance, 
            context={
                'sport_type': sport_type,
                'start_date': start_date, 
                'end_date': end_date,
                'period': period
            }
        )

        return response.Response(serializer.data, status=status.HTTP_200_OK)
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        
        return response.Response(serializer.data, status=status.HTTP_200_OK)
    