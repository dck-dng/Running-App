from rest_framework import serializers

from activity.models import Event, UserParticipationEvent
from account.serializers import DetailUserSerializer, LeaderboardSerializer
from social.serializers import EventPostSerializer
from activity.serializers.group import GroupSerializer
from utils.function import get_start_of_day, \
                            get_end_of_day, \
                            get_start_date_of_week, \
                            get_end_date_of_week, \
                            get_start_date_of_month, \
                            get_end_date_of_month, \
                            get_start_date_of_year, \
                            get_end_date_of_year
from utils.pagination import CommonPagination

class EventSerializer(serializers.ModelSerializer):
    competition = serializers.CharField(source='get_competition_display')
    check_user_join = serializers.SerializerMethodField()

    def get_check_user_join(self, instance):
        request_user_id = self.context["user"].id
        if request_user_id:
            instance = UserParticipationEvent.objects.filter(
                user_id=request_user_id, event_id=instance.id).first()
            return instance.id if instance else None
        return None
    
    class Meta:
        model = Event
        fields = (
            "id",
            "name",
            "total_participants",
            "competition",
            "banner",
            "days_remain",
            "check_user_join"
        )
        extra_kwargs = {
            "id": {"read_only": True}
        }
    
class DetailEventSerializer(serializers.ModelSerializer):
    days_remain = serializers.SerializerMethodField()
    participants = serializers.SerializerMethodField()
    groups = serializers.SerializerMethodField()
    privacy = serializers.CharField(source='get_privacy_display')
    competition = serializers.CharField(source='get_competition_display')
    sport_type = serializers.CharField(source='get_sport_type_display')
    started_at = serializers.SerializerMethodField()
    ended_at = serializers.SerializerMethodField()
    regulations = serializers.SerializerMethodField()
    posts = serializers.SerializerMethodField()
    check_user_join = serializers.SerializerMethodField()
    is_admin = serializers.SerializerMethodField()
    is_superadmin = serializers.SerializerMethodField()
    
    def get_posts(self, instance):
        context = self.context
        exclude = context.get('exclude', [])
        if 'posts' not in exclude:
            queryset = instance.event_posts.all()
            paginator = CommonPagination(page_size=5)
            paginated_queryset = paginator.paginate_queryset(queryset, self.context['request'])
            return EventPostSerializer(paginated_queryset, many=True, read_only=True, context={
                "user": context["user"],
                "request": context["request"],
            }).data
        return None
    
    def get_groups(self, instance):
        context = self.context
        exclude = context.get('exclude', [])
        if 'groups' not in exclude:
            queryset = instance.groups.all()
            return GroupSerializer(queryset, many=True, read_only=True).data
    
    def get_days_remain(self, instance):
        return instance.days_remain()
    
    # def get_participants(self, instance):
    #     request = self.context.get('request', None)
    #     users = [instance.user.performance for instance in instance.events.all()]
    #     return LeaderboardSerializer(users, many=True, context={'request': request}).data

    def get_participants(self, instance):
        context = self.context
        exclude = context.get('exclude', [])
        if 'participants' not in exclude:
            sport_type = instance.sport_type
            event_id = instance.id
            type = "event"
            
            start_date = context.get('start_date')
            end_date = context.get('end_date')
            gender = context.get('gender')
            sort_by = context.get('sort_by')
            limit_user = context.get('limit_user')

            print({'start_date': start_date, 'end_date': end_date, 'sort_by': sort_by, 'limit_user': limit_user})

            users = [instance.user.performance for instance in instance.events.all()]
            if gender:
                users = [user for user in users if user.user.profile.gender == gender]

            def sort_cmp(x, sort_by):
                stats = x.range_stats(start_date, end_date, sport_type=sport_type)
                if sort_by == 'Time':
                    return (-stats[3], -stats[0])
                return (-stats[0], -stats[3])
            users = sorted(users, key=lambda x: sort_cmp(x, sort_by))

            if limit_user:
                users = users[:int(limit_user)]

            return LeaderboardSerializer(users, many=True, context={
                'id': event_id,
                'type': type,
                'start_date': start_date,
                'end_date': end_date,
                'sport_type': sport_type,
                "request": context.get("request"),
            }).data
        return None
    
    def get_started_at(self, instance):
        return instance.get_readable_time('started_at')
    
    def get_ended_at(self, instance):
        return instance.get_readable_time('ended_at')
    
    def get_regulations(self, instance):
        regulations = instance.regulations
        if regulations is None:
            regulations = {
                "min_distance": "Unlimited",
                "max_distance": "Unlimited",
                "min_avg_pace": "Unlimited",
                "max_avg_pace": "Unlimited",
            }
        else:
            regulations["min_distance"] = f"{regulations.get('min_distance', 'Unlimited')}{'km' if regulations.get('min_distance', 'Unlimited') != 'Unlimited' else ''}"
            regulations["max_distance"] = f"{regulations.get('max_distance', 'Unlimited')}{'km' if regulations.get('max_distance', 'Unlimited') != 'Unlimited' else ''}"
            regulations["min_avg_pace"] = f"{regulations.get('min_avg_pace', 'Unlimited')}{'/km' if regulations.get('min_avg_pace', 'Unlimited') != 'Unlimited' else ''}"
            regulations["max_avg_pace"] = f"{regulations.get('max_avg_pace', 'Unlimited')}{'/km' if regulations.get('max_avg_pace', 'Unlimited') != 'Unlimited' else ''}"

        return regulations
    
    def get_check_user_join(self, instance):
        request_user_id = self.context["user"].id
        if request_user_id:
            instance = UserParticipationEvent.objects.filter(
                user_id=request_user_id, event_id=instance.id).first()
            return instance.id if instance else None
        return None
    
    def get_is_admin(self, instance):
        request_user = self.context.get("user")
        if request_user:
            request_user_id = request_user.id
            instance = UserParticipationEvent.objects.filter(
                user_id=request_user_id, event_id=instance.id).first()
            if instance:
                return instance.id if instance.is_admin else None
            else:
                return None
        return None
    
    def get_is_superadmin(self, instance):
        request_user = self.context.get("user")
        if request_user:
            request_user_id = request_user.id
            instance = UserParticipationEvent.objects.filter(
                user_id=request_user_id, event_id=instance.id).first()
            if instance:
                return instance.id if instance.is_superadmin else None
            else:
                return None
        return None
    
    class Meta:
        model = Event
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True}
        }


class CreateUpdateEventSerializer(serializers.ModelSerializer):
    def create(self, validated_data):
        validated_data["competition"] = validated_data.get("competition", "").upper()
        validated_data["sport_type"] = validated_data.get("sport_type", "").upper()
        validated_data["privacy"] = validated_data.get("privacy", "").upper()
        validated_data["ranking_type"] = validated_data.get("ranking_type", "").upper()

        return Event.objects.create(**validated_data)
    class Meta:
        model = Event
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True}
        }


