# Generated by Django 3.2.7 on 2024-04-17 08:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('activity', '0024_auto_20240413_0950'),
    ]

    operations = [
        migrations.AlterField(
            model_name='activityrecord',
            name='avg_heart_rate',
            field=models.IntegerField(default=155, null=True),
        ),
    ]
