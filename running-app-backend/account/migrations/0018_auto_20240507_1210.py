# Generated by Django 3.2.7 on 2024-05-07 05:10

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('account', '0017_auto_20240505_1038'),
    ]

    operations = [
        migrations.AddField(
            model_name='activity',
            name='total_ended_event_joined',
            field=models.IntegerField(blank=True, default=0, null=True),
        ),
        migrations.AddField(
            model_name='activity',
            name='total_event_joined',
            field=models.IntegerField(blank=True, default=0, null=True),
        ),
    ]
