# Generated by Django 3.2.7 on 2024-05-06 07:24

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('activity', '0056_auto_20240506_1313'),
    ]

    operations = [
        migrations.AlterField(
            model_name='activityrecord',
            name='avg_heart_rate',
            field=models.IntegerField(default=156, null=True),
        ),
    ]
