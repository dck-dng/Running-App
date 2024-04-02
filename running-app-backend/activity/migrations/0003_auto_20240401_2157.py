# Generated by Django 3.2.7 on 2024-04-01 14:57

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('activity', '0002_auto_20240401_1654'),
    ]

    operations = [
        migrations.AddField(
            model_name='userparticipationclub',
            name='is_approved',
            field=models.BooleanField(default=True),
        ),
        migrations.AddField(
            model_name='userparticipationclub',
            name='is_superadmin',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='userparticipationevent',
            name='is_approved',
            field=models.BooleanField(default=True),
        ),
        migrations.AddField(
            model_name='userparticipationgroup',
            name='is_approved',
            field=models.BooleanField(default=True),
        ),
        migrations.AddField(
            model_name='userparticipationgroup',
            name='is_superadmin',
            field=models.BooleanField(default=False),
        ),
    ]