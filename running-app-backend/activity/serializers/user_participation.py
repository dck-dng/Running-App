from rest_framework import serializers

from activity.models import UserParticipationClub, \
                            UserParticipationEvent, \
                            UserParticipationGroup  

from account.serializers import UserSerializer
from activity.serializers import ClubSerializer, \
                                EventSerializer, \
                                GroupSerializer
                                
# from account.serializers import ActivitySerializer                  

class UserParticipationClubSerializer(serializers.Serializer):
    user = serializers.SerializerMethodField()
    club = serializers.SerializerMethodField()
    is_admin = serializers.BooleanField()

    def get_user(self, instance):
        return instance.user.id
    
    def get_club(self, instance):
        return instance.club.id
    
    class Meta:
        model = UserParticipationClub
        fields = (
             "is_admin",
            "is_superadmin",
            "participated_at",
            "user",
            "club"
        )

class CreateUserParticipationClubSerializer(serializers.Serializer):
    id = serializers.SerializerMethodField()
    user_id = serializers.UUIDField(write_only=True)
    club_id = serializers.UUIDField(write_only=True)

    def get_id(self, instance):
        return instance.id
    
    def create(self, validated_data):
        user_id = validated_data.pop('user_id')
        club_id = validated_data.pop('club_id')
        return UserParticipationClub.objects.create(
            user_id=user_id, club_id=club_id, **validated_data)

    class Meta:
        model = UserParticipationClub
        fields = ("id", "user_id", "club_id")
        extra_kwargs = {
            "id": {"read_only": True}
        }

class UserParticipationEventSerializer(serializers.Serializer):
    # user = ActivitySerializer(many=False)
    event = EventSerializer()
    is_admin = serializers.BooleanField()
    is_superadmin = serializers.BooleanField()
    participated_at = serializers.DateTimeField()

    class Meta:
        model = UserParticipationEvent
        fields = (
            "is_admin",
            "is_superadmin",
            "participated_at",
            "user",
            "event"
        )

class CreateUserParticipationEventSerializer(serializers.Serializer):
    user_id = serializers.UUIDField()
    event_id = serializers.UUIDField()

    def create(self, validated_data):
        user_id = validated_data.pop('user_id')
        event_id = validated_data.pop('event_id')
        return UserParticipationEvent.objects.create(user_id=user_id, event_id=event_id, **validated_data)
    
    class Meta:
        model = UserParticipationEvent
        fields = ("id", "user_id", "event_id")


class UserParticipationGroupSerializer(serializers.Serializer):
    group = GroupSerializer()
    user = UserSerializer()

    class Meta:
        model = UserParticipationGroup
        fields = "__all__"

class CreateUserParticipationGroupSerializer(serializers.Serializer):
    user_id = serializers.UUIDField()
    group_id = serializers.UUIDField()

    def create(self, validated_data):
        user_id = validated_data.pop('user_id')
        group_id = validated_data.pop('group_id')
        return UserParticipationGroup.objects.create(user_id=user_id, group_id=group_id, **validated_data)

    class Meta:
        model = UserParticipationGroup
        fields = ("id", "user_id", "group_id")
