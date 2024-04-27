from rest_framework import serializers

from account.models.activity import Activity
from activity.models import ActivityRecord
from account.serializers import UserSerializer
from account.serializers.like import LikeSerializer
from account.serializers.author import AuthorSerializer
from social.serializers import ActivityRecordPostCommentSerializer
from utils.pagination import CommonPagination

class ActivityRecordSerializer(serializers.ModelSerializer):
    user = AuthorSerializer()
    completed_at = serializers.SerializerMethodField()
    avg_moving_pace = serializers.SerializerMethodField()
    
    def get_avg_moving_pace(self, instance):
        return instance.avg_moving_pace_readable()

    def get_completed_at(self, instance):
        return instance.get_readable_date('completed_at')
    
    class Meta:
        model = ActivityRecord
        fields = (
            "id", "user", "sport_type", 
            "points", "distance", 'privacy',
            "avg_moving_pace", "avg_cadence", "avg_heart_rate",
            "duration", "steps", "user",
            "kcal", "completed_at",
            "total_likes", "total_comments",
        )
        extra_kwargs = {
            "id": {"read_only": True},
            "user": {"read_only": True}
        }

class DetailActivityRecordSerializer(serializers.ModelSerializer):
    # user = serializers.SerializerMethodField()
    user = AuthorSerializer()
    completed_at = serializers.SerializerMethodField()
    sport_type = serializers.CharField(source='get_sport_type_display')
    privacy = serializers.CharField(source='get_privacy_display')
    avg_moving_pace = serializers.SerializerMethodField()
    kcal = serializers.SerializerMethodField()
    likes = serializers.SerializerMethodField()
    comments = serializers.SerializerMethodField()
    
    def get_author_id(self, instance):
        return instance.user.user.id
    
    def get_likes(self, instance):
        context = self.context
        exclude = context.get('exclude', [])
        print({'exclude': exclude})
        if 'likes' not in exclude:
            queryset = instance.likes.all()
            paginator = CommonPagination(page_size=100)
            paginated_queryset = paginator.paginate_queryset(queryset, self.context['request'])
            return LikeSerializer(paginated_queryset, many=True, read_only=True).data
        return None
    
    def get_comments(self, instance):
        context = self.context
        exclude = context.get('exclude', [])
        if 'comments' not in exclude:
            queryset = instance.comments.all()
            paginator = CommonPagination(page_size=5, page_query_param="cmt_pg")
            paginated_queryset = paginator.paginate_queryset(queryset, self.context['request'])
            return ActivityRecordPostCommentSerializer(paginated_queryset, many=True, read_only=True).data
        return None

    def get_completed_at(self, instance):
        return instance.get_readable_date_time('completed_at')

    # def get_user(self, instance):
    #     return UserSerializer(instance.user.user).data

    def get_avg_moving_pace(self, instance):
        return instance.avg_moving_pace_readable()
    
    def get_kcal(self, instance):
        return instance.kcal()
    
    class Meta:
        model = ActivityRecord
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True}
        }

class CreateActivityRecordSerializer(serializers.ModelSerializer):
    user_id = serializers.UUIDField()

    def create(self, validated_data):
        user_id = validated_data.pop('user_id')
        return ActivityRecord.objects.create(user_id=user_id, **validated_data)

    class Meta:
        model = ActivityRecord
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True},
            "user": {"read_only": True},
        }

class UpdateActivityRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActivityRecord
        fields = (
            "description",
            "title",
            "privacy",
        )

