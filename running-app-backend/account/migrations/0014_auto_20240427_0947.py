# Generated by Django 3.2.7 on 2024-04-27 02:47

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('account', '0013_alter_profile_avatar'),
    ]

    operations = [
        migrations.AddField(
            model_name='performance',
            name='total_points',
            field=models.IntegerField(default=0, null=True),
        ),
        migrations.AddField(
            model_name='performance',
            name='total_steps',
            field=models.IntegerField(default=0, null=True),
        ),
    ]
