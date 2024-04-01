from rest_framework import serializers

from account.models import Profile
from account.serializers import UserSerializer

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = (
            "id",
            "user",
            "full_name",            
        )
        extra_kwargs = {
            "id" : {"read_only": True},
            "user": {"read_only": True}
        }

class DetailProfileSerializer(serializers.ModelSerializer):
    full_name = serializers.SerializerMethodField()

    def get_full_name(self, instance):
        return instance.full_name()
    
    class Meta:
        model = Profile
        fields = "__all__"
        extra_kwargs = {
            "id" : {"read_only": True},
            # "user": {"read_only": True}
        }

class CreateProfileSerializer(serializers.ModelSerializer):
    name = serializers.CharField(write_only=True)
    
    class Meta:
        model = Profile
        fields = (
            "id", "first_name", "last_name", 
            "avatar", "updated_at", "country",
            "city", "gender", "date_of_birth",
            "height", "weight", "shirt_size",
            "trouser_size", "shoe_size",
        )
        extra_kwargs = {
            "id": {"read_only": True},
        }

    def create(self, validated_data):
        user_data = validated_data.pop('name', None)
        profile = Profile.objects.create(**validated_data)
        profile.user.name = user_data
        profile.user.save()
        
        return profile
    
    
    
class UpdateProfileSerializer(serializers.ModelSerializer):
    name = serializers.CharField(write_only=True)

    class Meta:
        model = Profile
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True},
        }

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['name'] = instance.user.first_name if instance.user.first_name else ""
        return data
    
    def update(self, instance, validated_data):
        user_data = validated_data.pop('name', None)
        if user_data:
            instance.user.name = user_data
            instance.user.save()
        return super().update(instance, validated_data)

