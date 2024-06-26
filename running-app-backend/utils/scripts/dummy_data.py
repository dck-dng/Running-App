import random
from datetime import timedelta
from faker import Faker
from django.db import connection
from django.contrib.auth.hashers import make_password

from rest_framework.authtoken.models import Token

from account.models import (User, Performance,
                        Privacy, Profile,
                        Activity, NotificationSetting)

from activity.models import (ActivityRecord, Club,
                            Group, Event,
                            UserParticipationClub,
                            UserParticipationEvent,
                            UserParticipationGroup)

from product.models import (Brand, Category, 
                            Product, ProductImage, 
                            UserProduct )

from social.models import (Follow, ClubPost, EventPost,
                            ClubPostImage, EventPostImage, 
                            ClubPostComment, EventPostComment,
                            ActivityRecordPostComment, 
                            EventPostLike, ClubPostLike, ActivityRecordPostLike
                            )
   


def generate_phone_number():
    area_code = random.choice(['20', '21', '22', '23', '24', '25', '26', '27', '28', '29',
                               '30', '31', '32', '33', '34', '35', '36', '37', '38', '39',
                               '50', '51', '52', '53', '54', '55', '56', '57', '58', '59',
                               '70', '76', '77', '78', '79', '81', '82', '83', '84', '85',
                               '86', '88', '89', '91', '92', '93', '94', '96', '97', '98'])
    
    subscriber_number = ''.join(random.choices('0123456789', k=7))
    
    phone_number = f"0{area_code}{subscriber_number}"
    
    return phone_number
  
fake = Faker()
def run():
    model_list = [
        User, Performance, Privacy, Profile, Activity,
        NotificationSetting, ActivityRecord, Club, Group, 
        UserParticipationGroup, Event, UserParticipationClub, 
        UserParticipationEvent, Brand, Category, Product, 
        ProductImage, UserProduct, Token,
        Follow, ClubPost, EventPost,
        ClubPostImage, EventPostImage, 
        ClubPostComment, EventPostComment,
        ActivityRecordPostComment,
        EventPostLike, ClubPostLike, ActivityRecordPostLike
        
    ]

    for model in model_list:
        model.objects.all().delete()

    MAX_NUMBER_USERS = 100
    MAX_NUMBER_USERS_FOLLOWERS = 50
    
    MAX_NUMBER_ACTIVITY_RECORDS = 10000
    MAX_COMMENTS_PER_ACTIVITY_RECORDS_POST = 30
    MAX_LIKES_PER_ACTIVITY_RECORDS_POST = 30

    MAX_NUMBER_EVENTS = 30
    MAX_POSTS_PER_EVENT = 30
    MAX_COMMENTS_PER_EVENT_POST = 50
    MAX_LIKES_PER_EVENT_POST = 50

    MAX_NUMBER_CLUBS = 50
    MAX_POSTS_PER_CLUB = 30
    MAX_COMMENTS_PER_CLUB_POST = 50
    MAX_LIKES_PER_CLUB_POST = 50

    MAX_NUMBER_EVENT_GROUPS = 200
    MAX_NUMBER_USER_EVENT_GROUPS = 30
    MAX_NUMBER_USER_PARTICIPATION_CLUBS = 30
    MAX_NUMBER_USER_PARTICIPATION_EVENTS = 20
    MAX_NUMBER_USER_PRODUCTS = 12
    MAX_NUMBER_PRODUCT_IMAGES = 30
    # MAX_NUMBER_CATEGORIES = 20
    # MAX_NUMBER_BRANDS = 20
    # MAX_NUMBER_PRODUCTS = 50
    
    print("________________________________________________________________")
    print("USER:")
    user_list = []
    user_activity_list = []
    for _ in range(MAX_NUMBER_USERS):
        data = {
            "email": "".join([fake.email().split("@")[0] for x in range(2)]) + "@gmail.com",
            "username": "".join([fake.email().split("@")[0] for x in range(2)]),
            "name": fake.name(),
            "phone_number": generate_phone_number(),
            "password": make_password("Duckkucd.123")
        }
        user = User.objects.create(**data)
        user_activity = Activity.objects.create(user=user)
        user_list.append(user)
        user_activity_list.append(user_activity)
        print(f"\tSuccesfully created User: {user}")
    # COMMENT IN USER MODEL

    
    print("________________________________________________________________")
    print("PROFILE:")
    profile_list = []
    for i in range(MAX_NUMBER_USERS):
        data = {
            "user": user_list[i],
            "avatar": f"avatar{random.randint(1, 8)}.jpg",
            "country": fake.country(),
            "city": fake.city(),
            "gender": random.choice(["MALE", "FEMALE"]),
            "date_of_birth": fake.date_time_between(start_date='-50y', end_date='-18y'),
            "height": random.randint(150, 200),
            "weight": random.randint(50, 100),
            "shirt_size": random.choice(['XS', 'S', 'M', 'L', 'XL', 'XXL']),
            "trouser_size": random.choice(['XS', 'S', 'M', 'L', 'XL', 'XXL']),
            "shoe_size": random.randint(36, 46),
        }
        profile = Profile.objects.create(**data)
        profile_list.append(profile)
        print(f"\tSuccesfully created Profile: {profile}")

    print("________________________________________________________________")
    print("FOLLOW:")
    follow_list = []
    for u in range(MAX_NUMBER_USERS):
        user_tmp = [user for user in user_activity_list if user != user_activity_list[u]]
        for i in range(random.randint(0, MAX_NUMBER_USERS_FOLLOWERS)): 
            random_user = user_tmp.pop(random.randint(0, len(user_tmp) - 1))
            data = {
                "followee": user_activity_list[u],
                "follower": random_user,
            }
            follow = Follow.objects.create(**data)
            follow_list.append(follow)
            print(f"\tSuccesfully created follow: {follow}")
    
    print("________________________________________________________________")
    print("PRIVACY")
    privacy_list = []
    for i in range(MAX_NUMBER_USERS):
        data = {
            "user": user_list[i],
            "follow_privacy": random.choice(["APPROVAL", "NO_APPROVAL"]),
            "activity_privacy": random.choice(["EVERYONE", "FOLLOWER", "ONLY YOU"]),
        }
        privacy = Privacy.objects.create(**data)
        privacy_list.append(privacy)
        print(f"\tSuccesfully created Privacy: {privacy}")
        
    print("________________________________________________________________")
    print("PERFORMANCE:")
    performance_list = []
    for i in range(MAX_NUMBER_USERS):
        data = {
            "user": user_list[i],
            "activity": user_activity_list[i],
        }
        performance = Performance.objects.create(**data)
        performance_list.append(performance)
        print(f"\tSuccesfully created Performance: {performance}")
    
    from datetime import datetime

    current_year = datetime.now().year
    current_datetime = datetime.now()

    print("________________________________________________________________")
    print("NOTIFICATION SETTING:")
    notification_setting_list = []
    for i in range(MAX_NUMBER_USERS):
        data = {
            "user": user_list[i],
            "finished_workout": random.choice([True, False]),
            "comment": random.choice([True, False]),
            "like": random.choice([True, False]),
            "mentions_on_activities": random.choice([True, False]),
            "respond_to_comments": random.choice([True, False]),
            "new_follower": random.choice([True, False]),
            "following_activity": random.choice([True, False]),
            "request_to_follow": random.choice([True, False]),
            "approved_follow_request": random.choice([True, False]),
            "pending_join_requests": random.choice([True, False]),
            "invited_to_club": random.choice([True, False]),
        }
        notification_setting = NotificationSetting.objects.create(**data)
        notification_setting_list.append(notification_setting)
        print(f"Succesfully created NotificationSetting for user {user}")

    print("________________________________________________________________")
    print("ACTIVITY RECORD:")
    activity_record_list = []
    for i in range(MAX_NUMBER_ACTIVITY_RECORDS):
        # start_date = current_datetime - timedelta(days=3*365)
        start_date = datetime(current_year, 1, 1)
        end_date = current_datetime
        completed_at = fake.date_time_between_dates(datetime_start=start_date, datetime_end=end_date)

        data = {
            "title": fake.text(max_nb_chars=50),
            "distance": random.uniform(0, 10),
            "duration": timedelta(hours=random.randint(0, 3), minutes=random.randint(0, 59), seconds=random.randint(0, 59)),
            "completed_at": completed_at,
            "sport_type": random.choice(["RUNNING", "CYCLING", "SWIMMING", "WALKING"]),
            'avg_heart_rate': random.randint(100, 160),
            "description": fake.text(max_nb_chars=250),
            "user": random.choice(user_activity_list),
        }
        activity_record = ActivityRecord.objects.create(**data)
        activity_record_list.append(activity_record)
        print(f"\tSuccesfully created Activity Record: {activity_record}")

    print("________________________________________________________________")
    print("CLUB:")
    club_list = []
    for i in range(MAX_NUMBER_CLUBS):
        data = {
            "name": fake.company(),
            "avatar": "",
            "cover_photo": "",
            "sport_type": random.choice(["RUNNING", "CYCLING", "SWIMMING"]),
            "description": fake.text(max_nb_chars=250),
            "privacy": random.choice(["Public", "Private"]),
            "organization": random.choice(["SPORT_CLUB", "COMPANY", "SCHOOL"]),
        }
        club = Club.objects.create(**data)
        club_list.append(club)
        print(f"\tSuccesfully created Club: {club}")
    
    print("________________________________________________________________")
    print("EVENT:")
    event_list = []
    started_time = fake.date_time_this_year()
    ended_time = fake.date_time_this_year()
    while ended_time <= started_time:
        ended_time = fake.date_time_this_year()
    for i in range(MAX_NUMBER_EVENTS):
        min_avg_pace = timedelta(hours=random.randint(0, 3), minutes=random.randint(0, 59))
        max_avg_pace = timedelta(hours=random.randint(0, 3), minutes=random.randint(0, 59))
        if max_avg_pace <= min_avg_pace:
            min_avg_pace, max_avg_pace = max_avg_pace, min_avg_pace
            
        data = {
            "name": fake.company(),
            "started_at": started_time,
            "ended_at": ended_time,
            "regulations": {
                "min_distance": 1,
                "max_distance": random.randint(80, 100),
                "min_avg_pace": str(min_avg_pace),
                "max_avg_pace": str(max_avg_pace),
            },
            "description": fake.text(max_nb_chars=250),
            "contact_information": fake.text(max_nb_chars=100),
            "banner": "",
            "sport_type": random.choice(["RUNNING", "CYCLING", "SWIMMING"]),
            "privacy": random.choice(["PUBLIC", "PRIVATE"]),
            "competition": random.choice(["INDIVIDUAL", "GROUP"])
        }
        event = Event.objects.create(**data)
        event_list.append(event)
        print(f"\tSuccesfully created Event: {event}")

    print("________________________________________________________________")
    print("EVENT GROUP:")
    event_group_list = []
    for i in range(MAX_NUMBER_EVENT_GROUPS):
        data = {
            "name": fake.company(),
            "description": fake.text(max_nb_chars=250),
            "avatar": "",
            "event": random.choice(event_list),
            "is_approved": True,
            # "is_approved": random.choice([True, False])
        }
        event_group = Group.objects.create(**data)
        event_group_list.append(event_group)
        print(f"\tSuccesfully created Event Group: {event_group}")
    
    print("________________________________________________________________")
    print("USER EVENT GROUP:")
    user_event_group_list = []
    for group in event_group_list:
        user_tmp = user_activity_list.copy()
        for i in range(random.randint(0, max(MAX_NUMBER_USER_EVENT_GROUPS, MAX_NUMBER_USERS))):
            random_user = user_tmp.pop(random.randint(0, len(user_tmp) - 1))
            data = {
                "user": random_user,
                "group": group,
                "is_superadmin": True if i == 0 else False,
                "is_admin": random.choice([True, False]),
                "is_approved": random.choice([True, False]) if group.privacy == "PRIVATE" else True,
                "participated_at": fake.date_time_this_year(),
            }
            user_event_group = UserParticipationGroup.objects.create(**data)
            user_event_group_list.append(user_event_group)
            print(f"\tSuccesfully created User Event Group: {user_event_group}")
    
    print("________________________________________________________________")
    print("USER PARTICIPATION CLUB:")
    user_participation_club_list = []
    for club in club_list:
        user_tmp = user_activity_list.copy()
        for i in range(random.randint(0, max(MAX_NUMBER_USER_PARTICIPATION_CLUBS, MAX_NUMBER_USERS))):
            random_user = user_tmp.pop(random.randint(0, len(user_tmp) - 1))
            data = {
                "user": random_user,
                "club": club,
                "is_superadmin": True if i == 0 else False,
                "is_admin": random.choice([True, False]),
                "is_approved": random.choice([True, False]) if club.privacy == "PRIVATE" else True,
                "participated_at": fake.date_time_this_year(),
            }
            user_participation_club = UserParticipationClub.objects.create(**data)
            user_participation_club_list.append(user_participation_club)
            print(f"\tSuccesfully created User Participation Club: {user_participation_club}")
    
    print("________________________________________________________________")
    print("USER PARTICIPATION EVENT:")
    user_participation_event_list = []
    for event in event_list:
        user_tmp = user_activity_list.copy()
        for i in range(random.randint(0, max(MAX_NUMBER_USER_PARTICIPATION_EVENTS, MAX_NUMBER_USERS))):
            random_user = user_tmp.pop(random.randint(0, len(user_tmp) - 1))
            data = {
                "user": random_user,
                "event": event,
                "is_superadmin": True if i == 0 else False,
                "is_admin": random.choice([True, False]),
                "is_approved": random.choice([True, False]) if event.privacy == "PRIVATE" else True,
                "participated_at": fake.date_time_this_year(),
            }
            user_participation_event = UserParticipationEvent.objects.create(**data)
            user_participation_event_list.append(user_participation_event)
            print(f"\tSuccesfully created User Participation Event: {user_participation_event}")

    
    print("________________________________________________________________")
    print("CATEGORY:")
    categories = [
        "Shoes", "Apparel", "Accessories", "Watches", "Hydration Packs", "Socks", "Hats", "Gloves", "Sunglasses",
        "Swimsuits", "Goggles", "Caps", "Training Equipment", "Fins", "Paddles", "Snorkels", "Kickboards", "Buoy",
        "Bikes", "Apparel", "Accessories", "Helmets", "Shoes", "Gloves", "Sunglasses", "Jerseys", "Shorts"
    ]
    category_list = []
    for category_ in categories:
        random_event = random.choice(event_list)
        data = {
            "name": category_,
        }
        category = Category.objects.create(**data)
        category_list.append(category)
        print(f"\tSuccesfully created Category: {category}")
    
    print("________________________________________________________________")
    print("BRAND:")
    brands = ["Nike", "Adidas", "New Balance", "Asics", "Brooks", "Saucony", "Under Armour", "Puma", "Reebok",
                "Speedo", "TYR", "Arena", "FINIS", "Dolfin", "Funky Trunks", "MP Michael Phelps", "Zoggs", "Aqua Sphere"
                "Giant", "Trek", "Specialized", "Cannondale", "Scott", "Bianchi", "Cervélo", "Felt", "Colnago"]
    brand_list = []
    for brand_  in brands:
        random_event = random.choice(event_list)
        data = {
            "name": brand_,
            "logo": ""
        }
        brand = Brand.objects.create(**data)
        brand_list.append(brand)
        print(f"\tSuccesfully created Brand: {brand}")
        
    print("________________________________________________________________")
    print("PRODUCT:")
    products = [
        "RunSwimCyclone Shoes", "AquaticStride Apparel", "TriathlonGear Accessories", 
        "AeroStream Watches", "HydroFlow Hydration Packs", "StrideWave Socks",
        "CycleRide Hats", "RunAqua Gloves", "TriathlonTrek Sunglasses",
        "AquaGlide Swimsuits", "CycleMotion Goggles", "RunSwimCap Caps",
        "TriathlonTraining Equipment", "AquaForce Fins", "CyclePaddle Paddles", 
        "RunRipple Snorkels", "SwimStride Kickboards", "CycleBoost Buoy",
        "TriBike Bikes", "AquaThrust Apparel", "CycleGlide Accessories",
        "TriHelmet Helmets", "RunCycle Shoes", "AquaGrip Gloves",
        "TriathlonShade Sunglasses", "CycleJersey Jerseys", "RunShorts Shorts"
    ]
    product_list = []
    for product_ in products:
        random_event = random.choice(event_list)
        data = {
            "name": product_,
            "brand": random.choice(brand_list),
            "category": random.choice(category_list),
            "price": random.randint(0, 1000),
            "description": fake.text(max_nb_chars=250),
        }
        product = Product.objects.create(**data)
        product_list.append(product)
        print(f"\tSuccesfully created Product: {product}")
    
    print("________________________________________________________________")
    print("PRODUCT IMAGE:")
    product_image_list = []
    for product in product_list:
        for i in range(random.randint(0, MAX_NUMBER_PRODUCT_IMAGES)):
            data = {
                "product": product,  
                "image": "",
            }
            product_image = ProductImage.objects.create(**data)
            product_image_list.append(product_image)
            print(f"\tSuccesfully created Product Image: {product_image}")
    
    print("________________________________________________________________")
    print("USER PRODUCT:")
    user_product_list = []
    for user in user_activity_list:
        product_tmp = product_list.copy()
        for i in range(random.randint(0, MAX_NUMBER_USER_PRODUCTS)):
            random_product = product_tmp.pop(random.randint(0, len(product_tmp) - 1))
            data = {
                "user": user,
                "product": random_product,
            }
            user_product = UserProduct.objects.create(**data)
            user_product_list.append(user_product)
            print(f"\tSuccesfully created User Product: {user_product}")

    print("________________________________________________________________")
    print("CLUB POST:")
    club_post_list = []
    for i in range(MAX_NUMBER_CLUBS):
        tmp = []
        for _ in range(random.randint(0, MAX_POSTS_PER_CLUB)):
            data = {
                "title": fake.text(max_nb_chars=50),
                "content": fake.text(max_nb_chars=250),
                "user": random.choice(user_activity_list),
                "club": club_list[i]
            }
            club_post = ClubPost.objects.create(**data)
            tmp.append(club_post)
            print(f"\tSuccesfully created Club post: {club_post}")
        club_post_list.append(tmp)

    print("________________________________________________________________")
    print("EVENT POST:")
    event_post_list = []
    for i in range(MAX_NUMBER_EVENTS):
        tmp = []
        for _ in range(random.randint(0, MAX_POSTS_PER_EVENT)):
            data = {
                "title": fake.text(max_nb_chars=50),
                "content": fake.text(max_nb_chars=250),
                "user": random.choice(user_activity_list),
                "event": event_list[i]
            }
            event_post = EventPost.objects.create(**data)
            tmp.append(event_post)
            print(f"\tSuccesfully created Event post: {event_post}")
        event_post_list.append(tmp)

    print("________________________________________________________________")
    print("CLUB POST COMMENT:")
    club_post_comment_list = []
    for i in range(MAX_NUMBER_CLUBS):
        for post in club_post_list[i]:
            for _ in range(random.randint(0, MAX_COMMENTS_PER_CLUB_POST)):
                data = {
                    "user": random.choice(user_activity_list),
                    "content": fake.text(max_nb_chars=250),
                    "post": post
                }
                club_post_comment = ClubPostComment.objects.create(**data)
                club_post_comment_list.append(club_post_comment)
                print(f"\tSuccesfully created club post comment: {club_post_comment}")

    print("________________________________________________________________")
    print("EVENT POST COMMENT:")
    event_post_comment_list = []
    for i in range(MAX_NUMBER_EVENTS):
        for post in event_post_list[i]:
            for _ in range(random.randint(0, MAX_COMMENTS_PER_EVENT_POST)):
                data = {
                    "user": random.choice(user_activity_list),
                    "content": fake.text(max_nb_chars=250),
                    "post": post
                }
                event_post_comment = EventPostComment.objects.create(**data)
                event_post_comment_list.append(event_post_comment)
                print(f"\tSuccesfully created event post comment: {event_post_comment}")

    print("________________________________________________________________")
    print("ACTIVIY RECORD POST COMMENT:")
    activity_record_post_comment_list = []
    for i in range(MAX_NUMBER_ACTIVITY_RECORDS):
        for _ in range(random.randint(0, MAX_COMMENTS_PER_ACTIVITY_RECORDS_POST)):
            data = {
                "user": random.choice(user_activity_list),
                "content": fake.text(max_nb_chars=250),
                "post": activity_record_list[i]
            }
            activity_record_post_comment = ActivityRecordPostComment.objects.create(**data)
            activity_record_post_comment_list.append(activity_record_post_comment)
            print(f"\tSuccesfully created activity record post comment: {activity_record_post_comment}")
    
    print("________________________________________________________________")
    print("CLUB POST LIKE:")
    club_post_like_list = []
    for i in range(MAX_NUMBER_CLUBS):
        for post in club_post_list[i]:
            user_tmp = user_activity_list.copy()
            for _ in range(random.randint(0, MAX_LIKES_PER_CLUB_POST)):
                random_user = user_tmp.pop(random.randint(0, len(user_tmp) - 1))
                data = {
                    "user": random_user,
                    "post": post
                }
                club_post_like = ClubPostLike.objects.create(**data)
                club_post_like_list.append(club_post_like)
                print(f"\tSuccesfully created club like comment: {club_post_like}")
    
    print("________________________________________________________________")
    print("EVENT POST COMMENT:")
    event_post_like_list = []
    for i in range(MAX_NUMBER_EVENTS):
        for post in event_post_list[i]:
            user_tmp = user_activity_list.copy()
            for _ in range(random.randint(0, MAX_LIKES_PER_EVENT_POST)):
                random_user = user_tmp.pop(random.randint(0, len(user_tmp) - 1))
                data = {
                    "user": random_user,
                    "post": post
                }
                event_post_like = EventPostLike.objects.create(**data)
                event_post_like_list.append(event_post_like)
                print(f"\tSuccesfully created event post like: {event_post_like}")

    print("________________________________________________________________")
    print("ACTIVIY RECORD POST LIKE:")
    activity_record_post_like_list = []
    for i in range(MAX_NUMBER_ACTIVITY_RECORDS):
        user_tmp = user_activity_list.copy()
        for _ in range(random.randint(0, MAX_LIKES_PER_ACTIVITY_RECORDS_POST)):
            random_user = user_tmp.pop(random.randint(0, len(user_tmp) - 1))
            data = {
                "user": random_user,
                "post": activity_record_list[i]
            }
            activity_record_post_like = ActivityRecordPostLike.objects.create(**data)
            activity_record_post_like_list.append(activity_record_post_like)
            print(f"\tSuccesfully created activity record post like: {activity_record_post_like}")
    
    User.objects.create_superuser(username="duc", password="Duckkucd.123", email="duc@gmail.com")


    

