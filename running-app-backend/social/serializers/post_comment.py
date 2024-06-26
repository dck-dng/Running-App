from rest_framework import serializers
from account.serializers.user_abbr import UserAbbrSerializer
from social.models import ClubPostComment,\
                            EventPostComment, \
                            ActivityRecordPostComment

        
class ClubPostCommentSerializer(serializers.ModelSerializer):
    user = UserAbbrSerializer()

    class Meta:
        model = ClubPostComment
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True},
        }
class CreateClubPostCommentSerializer(serializers.ModelSerializer):
    user_id = serializers.UUIDField(write_only=True)
    post_id = serializers.UUIDField(write_only=True)
    user = serializers.SerializerMethodField()

    def get_user(self, instance):
        return UserAbbrSerializer(instance.user, context={
            "request": self.context.get("request")
        }).data
    
    def create(self, validated_data):
        user_id = validated_data.pop("user_id")
        post_id = validated_data.pop("post_id")
        comment = ClubPostComment.objects.create(
            user_id=user_id, post_id=post_id, **validated_data)
        return comment
    
    class Meta:
        model = ClubPostComment
        fields = (
            "id", "user", "content",
            "created_at", "post", "post_id", "user_id"
        )
        extra_kwargs = {
            "id": {"read_only": True},
            "post": {"read_only": True},
            "user": {"read_only": True},
            "post_id": {"write_only": True},
            "user_id": {"write_only": True},
        }

class EventPostCommentSerializer(serializers.ModelSerializer):
    user = UserAbbrSerializer()
    class Meta:
        model = EventPostComment
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True},
        }

class CreateEventPostCommentSerializer(serializers.ModelSerializer):
    user_id = serializers.UUIDField(write_only=True)
    post_id = serializers.UUIDField(write_only=True)
    user = serializers.SerializerMethodField()

    def get_user(self, instance):
        return UserAbbrSerializer(instance.user, context={
            "request": self.context.get("request")
        }).data
    
    def create(self, validated_data):
        user_id = validated_data.pop("user_id")
        post_id = validated_data.pop("post_id")
        comment = EventPostComment.objects.create(
            user_id=user_id, post_id=post_id, **validated_data)
        return comment
    
    class Meta:
        model = EventPostComment
        fields = (
            "id", "user", "content",
            "created_at", "post", "post_id", "user_id"
        )
        extra_kwargs = {
            "id": {"read_only": True},
            "post": {"read_only": True},
            "user": {"read_only": True},
            "post_id": {"write_only": True},
            "user_id": {"write_only": True},
        }

class ActivityRecordPostCommentSerializer(serializers.ModelSerializer):
    user = UserAbbrSerializer()
    
    class Meta:
        model = ActivityRecordPostComment
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True},
        }


class CreateActivityRecordPostCommentSerializer(serializers.ModelSerializer):
    user_id = serializers.UUIDField()
    post_id = serializers.UUIDField()
    user = serializers.SerializerMethodField()

    def get_user(self, instance):
        return UserAbbrSerializer(instance.user, context={
            "request": self.context.get("request")
        }).data
    
    def create(self, validated_data):
        user_id = validated_data.pop("user_id")
        post_id = validated_data.pop("post_id")
        comment = ActivityRecordPostComment.objects.create(
            user_id=user_id, post_id=post_id, **validated_data)
        return comment
    
    class Meta:
        model = ActivityRecordPostComment
        fields = (
            "id", "user", "content",
            "created_at", "post", "post_id", "user_id"
        )
        extra_kwargs = {
            "id": {"read_only": True},
            "post": {"read_only": True},
            "user": {"read_only": True},
            "post_id": {"write_only": True},
            "user_id": {"write_only": True},
        }
