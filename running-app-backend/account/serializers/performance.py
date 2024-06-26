from datetime import datetime, timedelta

from rest_framework import serializers

from account.models import Performance
from activity.models import UserParticipationClub, \
                            UserParticipationEvent
from social.models import Follow
from account.serializers.user import UserSerializer

from utils.function import get_start_of_day, \
                            get_end_of_day, \
                            get_start_date_of_week, \
                            get_end_date_of_week, \
                            get_start_date_of_month, \
                            get_end_date_of_month, \
                            get_start_date_of_year, \
                            get_end_date_of_year

class LeaderboardSerializer(serializers.ModelSerializer):
    name = serializers.SerializerMethodField()
    avatar = serializers.SerializerMethodField()
    user_id = serializers.SerializerMethodField()
    act_id = serializers.SerializerMethodField()
    gender = serializers.SerializerMethodField()
    total_distance = serializers.SerializerMethodField()
    total_duration = serializers.SerializerMethodField()
    participated_at = serializers.SerializerMethodField()
    check_user_follow = serializers.SerializerMethodField()
    
    def get_user_id(self, instance):
        return instance.user.id
    
    def get_avatar(self, instance):
        request = self.context.get('request')
        avatar = instance.user.profile.avatar
        if request and avatar:
            return request.build_absolute_uri(f"/static/images/avatars/{avatar}")
        return None

    def get_act_id(self, instance):
        return instance.activity.id if self.check_follow() else None
    
    def get_name(self, instance):
        return instance.user.name

    def get_gender(self, instance):
        return instance.user.profile.gender
    
    def get_period_stats(self, instance, index):
        context = self.context
        start_date = context.get('start_date')
        end_date = context.get('end_date')
        type = context.get('type')
        
        sport_type = context.get('sport_type') if type else "RUNNING"
        return instance.range_stats(start_date, end_date, sport_type=sport_type)[index]
    
    def check_follow(self):
        return bool(self.context.get("check_follow", False))

    def get_total_distance(self, instance):
        return self.get_period_stats(instance, 0) if not self.check_follow() else None
    
    def get_total_duration(self, instance):
        return instance.format_duration(self.get_period_stats(instance, 3)) \
            if not self.check_follow() else None

    def get_total_points(self, instance):
        return self.get_period_stats(instance, 2) \
            if not self.check_follow() else None
    
    def get_participated_at(self, instance):
        type = self.context.get("type", None)
        id = self.context.get("id", None)
        user_id = instance.user.activity.id
        if type == "club":
            return UserParticipationClub.objects.get(user_id=user_id, club_id=id).participated_at
        elif type == "event":
            return UserParticipationEvent.objects.get(user_id=user_id, event_id=id).participated_at    
        return None

    def get_check_user_follow(self, instance):
        if self.check_follow():
            request_user = self.context.get("user")
            if request_user:
                request_user_id = request_user.id
                instance = Follow.objects.\
                    filter(follower=request_user_id, followee=instance.activity.id).first()
                print(instance)
                return instance.id if instance else None
        return None
    
    class Meta:
        model = Performance
        fields = (
            "id", 
            "user_id",
            "act_id",
            "name",
            "avatar",
            "gender",
            "total_duration",
            "total_distance",
            "participated_at",
            "check_user_follow",
        )
        extra_kwargs = {
            "id": {"read_only": True},
        }
        ordering = ("total_distance")

class PerformanceSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    level = serializers.SerializerMethodField()
    steps_done_this_level = serializers.SerializerMethodField()
    total_steps_this_level = serializers.SerializerMethodField()
    period_distance = serializers.SerializerMethodField()
    period_steps = serializers.SerializerMethodField()
    period_points = serializers.SerializerMethodField()
    period_duration = serializers.SerializerMethodField()
    period_avg_moving_pace = serializers.SerializerMethodField()
    period_avg_total_cadence = serializers.SerializerMethodField()
    period_avg_total_heart_rate = serializers.SerializerMethodField()
    period_active_days = serializers.SerializerMethodField()
    
    def get_period_stats(self, instance, index):
        period = self.context.get('period', None)
        start_date = self.context.get('start_date', None)
        end_date = self.context.get('end_date', None)
        sport_type = self.context.get('sport_type', None)
        # print(sport_type)
        # print({'start_date': start_date, 'end_date': end_date})

        if period:
            if period == 'daily':
                return instance.daily_stats(sport_type)[index]
            elif period == 'weekly':
                return instance.weekly_stats(sport_type)[index]
            elif period == 'monthly':
                return instance.monthly_stats(sport_type)[index]
            elif period == 'yearly':
                return instance.yearly_stats(sport_type)[index]
        elif start_date and end_date:
            return instance.range_stats(start_date, end_date, sport_type)[index]
        
        return instance.total_stats(sport_type)[index]

    def get_period_distance(self, instance):
        return self.get_period_stats(instance, 0)

    def get_period_steps(self, instance):
        return self.get_period_stats(instance, 1)

    def get_period_points(self, instance):
        return self.get_period_stats(instance, 2)

    def get_period_duration(self, instance):
        return instance.format_duration(self.get_period_stats(instance, 3))

    def get_period_avg_moving_pace(self, instance):
        return self.get_period_stats(instance, 4)

    def get_period_avg_total_cadence(self, instance):
        return round(self.get_period_stats(instance, 5)) if self.get_period_stats(instance, 5) else None

    def get_period_avg_total_heart_rate(self, instance):
        return round(self.get_period_stats(instance, 6)) if self.get_period_stats(instance, 6) else None

    def get_period_active_days(self, instance):
        return self.get_period_stats(instance, 7)
        
    def get_level(self, instance):
        return instance.level()

    def get_steps_done_this_level(self, instance):
        return instance.steps_done_this_level()
    
    def get_total_steps_this_level(self, instance):
        return instance.total_steps_this_level()
        
    class Meta:
        model = Performance
        # fields = "__all__"
        exclude = ("activity",)
        extra_kwargs = {
            "id": {"read_only": True},
        }

    # def get_period_distance(self, instance):
    #     period = self.context.get('period', None)
    #     start_date = self.context.get('start_date', None)
    #     end_date = self.context.get('end_date', None)
        
    #     if period:
    #         if period == 'daily':
    #             return instance.daily_stats()[0]
    #         elif period == 'weekly':
    #             return instance.weekly_stats()[0]
    #         elif period == 'monthly':
    #             return instance.monthly_stats()[0]
    #         elif period == 'yearly':
    #             return instance.yearly_stats()[0]
    #     elif start_date and end_date:
    #         return instance.range_stats(start_date, end_date)[0]

    #     return instance.total_distance()
        
    
    # def get_period_steps(self, instance):
    #     period = self.context.get('period', None)
    #     start_date = self.context.get('start_date', None)
    #     end_date = self.context.get('end_date', None)

    #     if period:
    #         if period == 'daily':
    #             return instance.daily_stats()[1]
    #         elif period == 'weekly':
    #             return instance.weekly_stats()[1]
    #         elif period == 'monthly':
    #             return instance.monthly_stats()[1]
    #         elif period == 'yearly':
    #             return instance.yearly_stats()[1]
    #     elif start_date and end_date:
    #         return instance.range_stats(start_date, end_date)[1]        
            
    #     return instance.total_steps()

    # def get_period_points(self, instance):
    #     period = self.context.get('period', None)
    #     start_date = self.context.get('start_date', None)
    #     end_date = self.context.get('end_date', None)
    #     print({'period': period, 'start_date': start_date})
    #     if period:
    #         if period == 'daily':
    #             return instance.daily_stats()[2]
    #         elif period == 'weekly':
    #             return instance.weekly_stats()[2]
    #         elif period == 'monthly':
    #             return instance.monthly_stats()[2]
    #         elif period == 'yearly':
    #             return instance.yearly_stats()[2]
    #     elif start_date and end_date:
    #         return instance.range_stats(start_date, end_date)[2]

    #     return instance.total_points()

    # def get_period_duration(self, instance):
    #     period = self.context.get('period', None)
    #     start_date = self.context.get('start_date', None)
    #     end_date = self.context.get('end_date', None)

    #     if period:
    #         if period == 'daily':
    #             return instance.daily_stats()[3]
    #         elif period == 'weekly':
    #             return instance.weekly_stats()[3]
    #         elif period == 'monthly':
    #             return instance.monthly_stats()[3]
    #         elif period == 'yearly':
    #             return instance.yearly_stats()[3]
    #     elif start_date and end_date:
    #         return instance.range_stats(start_date, end_date)[3]

    #     return instance.total_duration()

    # def get_period_avg_total_cadence(self, instance):
    #     period = self.context.get('period', None)
    #     start_date = self.context.get('start_date', None)
    #     end_date = self.context.get('end_date', None)

    #     if period:
    #         if period == 'daily':
    #             return instance.daily_stats()[4]
    #         elif period == 'weekly':
    #             return instance.weekly_stats()[4]
    #         elif period == 'monthly':
    #             return instance.monthly_stats()[4]
    #         elif period == 'yearly':
    #             return instance.yearly_stats()[4]
    #     elif start_date and end_date:
    #         return instance.range_stats(start_date, end_date)[4]

    #     return instance.avg_total_cadence()

    # def get_period_avg_total_heart_rate(self, instance):
    #     period = self.context.get('period', None)
    #     start_date = self.context.get('start_date', None)
    #     end_date = self.context.get('end_date', None)

    #     if period:
    #         if period == 'daily':
    #             return instance.daily_stats()[5]
    #         elif period == 'weekly':
    #             return instance.weekly_stats()[5]
    #         elif period == 'monthly':
    #             return instance.monthly_stats()[5]
    #         elif period == 'yearly':
    #             return instance.yearly_stats()[5]
    #     elif start_date and end_date:
    #         return instance.range_stats(start_date, end_date)[5]
    
    #     return instance.avg_total_heart_rate()

    # def get_period_active_days(self, instance):
    #     period = self.context.get('period', None)
    #     start_date = self.context.get('start_date', None)
    #     end_date = self.context.get('end_date', None)

    #     if period:
    #         if period == 'daily':
    #             return instance.daily_stats()[6]
    #         elif period == 'weekly':
    #             return instance.weekly_stats()[6]
    #         elif period == 'monthly':
    #             return instance.monthly_stats()[6]
    #         elif period == 'yearly':
    #             return instance.yearly_stats()[6]
    #     elif start_date and end_date:
    #         return instance.range_stats(start_date, end_date)[6]

    #     return instance.total_active_days()
    
    # def get_range_distance(self, instance):
    #     start_date = self.context.get('start_date', None)
    #     end_date = self.context.get('end_date', None)
    #     if start_date and end_date:
    #         start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
    #         end_date = datetime.strptime(end_date, '%Y-%m-%d').date()
    #         return instance.range_stats(start_date, end_date)
    #    return None
    
    
    # total_distance = serializers.SerializerMethodField()
    # total_steps = serializers.SerializerMethodField()
    # total_points = serializers.SerializerMethodField()
    # total_duration = serializers.SerializerMethodField()
    # avg_total_cadence = serializers.SerializerMethodField()
    # avg_total_heart_rate = serializers.SerializerMethodField()
    
    # daily_distance = serializers.SerializerMethodField()
    # weekly_distance = serializers.SerializerMethodField()
    # monthly_distance = serializers.SerializerMethodField()
    # yearly_distance = serializers.SerializerMethodField()
    
    # daily_steps = serializers.SerializerMethodField()
    # weekly_steps = serializers.SerializerMethodField()
    # monthly_steps = serializers.SerializerMethodField()
    # yearly_steps = serializers.SerializerMethodField()
    
    # daily_points = serializers.SerializerMethodField()
    # weekly_points = serializers.SerializerMethodField()
    # monthly_points = serializers.SerializerMethodField()
    # yearly_points = serializers.SerializerMethodField()
    
    # daily_duration = serializers.SerializerMethodField()
    # weekly_duration = serializers.SerializerMethodField()
    # monthly_duration = serializers.SerializerMethodField()
    # yearly_duration = serializers.SerializerMethodField()
    
    # daily_avg_total_cadence = serializers.SerializerMethodField()
    # weekly_avg_total_cadence = serializers.SerializerMethodField()
    # monthly_avg_total_cadence = serializers.SerializerMethodField()
    # yearly_avg_total_cadence = serializers.SerializerMethodField()
    
    # daily_avg_total_heart_rate = serializers.SerializerMethodField()
    # weekly_avg_total_heart_rate = serializers.SerializerMethodField()
    # monthly_avg_total_heart_rate = serializers.SerializerMethodField()
    # yearly_avg_total_heart_rate = serializers.SerializerMethodField()
    
    # weekly_active_days = serializers.SerializerMethodField()
    # monthly_active_days = serializers.SerializerMethodField()
    # yearly_active_days = serializers.SerializerMethodField()
    
    # def get_total_distance(self, instance):
    #     return instance.total_distance()
    
    # def get_total_steps(self, instance):
    #     return instance.total_steps()
    
    # def get_total_points(self, instance):
    #     return instance.total_points()
    
    # def get_total_duration(self, instance):
    #     return instance.total_duration()

    # def get_avg_total_cadence(self, instance):
    #     return instance.avg_total_cadence()

    # def get_avg_total_heart_rate(self, instance):
    #     return instance.avg_total_heart_rate()

    # def get_daily_distance(self, instance):
    #     return instance.daily_stats()[0]
    
    # def get_weekly_distance(self, instance):
    #     return instance.weekly_stats()[0]
    
    # def get_monthly_distance(self, instance):
    #     return instance.monthly_stats()[0]
    
    # def get_yearly_distance(self, instance):
    #     return instance.yearly_stats()[0]


    # def get_daily_steps(self, instance):
    #     return instance.daily_stats()[1]
    
    # def get_weekly_steps(self, instance):
    #     return instance.weekly_stats()[1]
    
    # def get_monthly_steps(self, instance):
    #     return instance.monthly_stats()[1]
    
    # def get_yearly_steps(self, instance):
    #     return instance.yearly_stats()[1]
    

    # def get_daily_points(self, instance):
    #     return instance.daily_stats()[2]
    
    # def get_weekly_points(self, instance):
    #     return instance.weekly_stats()[2]
    
    # def get_monthly_points(self, instance):
    #     return instance.monthly_stats()[2]
    
    # def get_yearly_points(self, instance):
    #     return instance.yearly_stats()[2]


    # def get_daily_duration(self, instance):
    #     return format(instance.daily_stats()[3])
    
    # def get_weekly_duration(self, instance):
    #     return format(instance.monthly_stats()[3])
    
    # def get_monthly_duration(self, instance):
    #     return format(instance.weekly_stats()[3])
    
    # def get_yearly_duration(self, instance):
    #     return format(instance.yearly_stats()[3])


    # def get_daily_avg_total_cadence(self, instance):
    #     return instance.daily_stats()[4]

    # def get_weekly_avg_total_cadence(self, instance):
    #     return instance.weekly_stats()[4]

    # def get_monthly_avg_total_cadence(self, instance):
    #     return instance.monthly_stats()[4]

    # def get_yearly_avg_total_cadence(self, instance):
    #     return instance.yearly_stats()[4]
    

    # def get_daily_avg_total_heart_rate(self, instance):
    #     return instance.daily_stats()[5]

    # def get_weekly_avg_total_heart_rate(self, instance):
    #     return instance.weekly_stats()[5]

    # def get_monthly_avg_total_heart_rate(self, instance):
    #     return instance.monthly_stats()[5]

    # def get_yearly_avg_total_heart_rate(self, instance):
    #     return instance.yearly_stats()[5]  
        

    # def get_weekly_active_days(self, instance):
    #     return instance.yearly_stats()[6]
    
    # def get_monthly_active_days(self, instance):
    #     return instance.yearly_stats()[6]
    
    # def get_yearly_active_days(self, instance):
    #     return instance.yearly_stats()[6]

class CreatePerformanceSerializer(serializers.ModelSerializer):
    user_id = serializers.UUIDField()

    def create(self, validated_data):
        user_id = validated_data.pop('user_id')
        return Performance.objects.create(user_id=user_id, **validated_data)
    
    class Meta:
        model = Performance
        fields = "__all__"
        extra_kwargs = {
            "id": {"read_only": True},
            "user": {"read_only": True}
        }