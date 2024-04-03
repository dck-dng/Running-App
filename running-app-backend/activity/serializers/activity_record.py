from rest_framework import serializers

from activity.models import ActivityRecord
from account.serializers import UserSerializer

class ActivityRecordSerializer(serializers.ModelSerializer):
    completed_at = serializers.SerializerMethodField()
    name = serializers.SerializerMethodField()
    def get_completed_at(self, instance):
        return instance.get_readable_date('completed_at')
    def get_name(self, instance):
        return instance.user.user.name

    class Meta:
        model = ActivityRecord
        fields = (
            "id", 
            "name",
            "sport_type", 
            "points",
            "distance",
            "avg_moving_pace",
            "avg_cadence",
            "avg_heart_rate",
            "duration",
            "steps", 
            "user",
            "kcal", 
            "completed_at"
        )
        extra_kwargs = {
            "id": {"read_only": True},
            "user": {"read_only": True}
        }

class DetailActivityRecordSerializer(serializers.ModelSerializer):
    user = serializers.SerializerMethodField()
    completed_at = serializers.SerializerMethodField()
    sport_type = serializers.CharField(source='get_sport_type_display')
    avg_moving_pace = serializers.SerializerMethodField()
    kcal = serializers.SerializerMethodField()
    
    def get_completed_at(self, instance):
        return instance.get_readable_date_time('completed_at')

    def get_user(self, instance):
        return UserSerializer(instance.user.user).data

    def get_avg_moving_pace(self, instance):
        return instance.avg_moving_pace()
    
    def get_kcal(self, instance):
        return instance.kcal()
    
    class Meta:
        model = ActivityRecord
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True}
        }

class CreateActivityRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActivityRecord
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True},
        }

class UpdateActivityRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActivityRecord
        fields = ("description",)

