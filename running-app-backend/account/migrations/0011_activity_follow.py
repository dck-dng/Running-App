# Generated by Django 3.2.7 on 2024-04-17 08:56

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('social', '0002_rename_activity_record_activityrecordpostcomment_post'),
        ('account', '0010_auto_20240412_0943'),
    ]

    operations = [
        migrations.AddField(
            model_name='activity',
            name='follow',
            field=models.ManyToManyField(through='social.Follow', to='account.Activity'),
        ),
    ]