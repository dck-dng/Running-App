# Generated by Django 3.2.7 on 2024-05-07 05:10

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('activity', '0057_alter_activityrecord_avg_heart_rate'),
    ]

    operations = [
        migrations.AlterField(
            model_name='activityrecord',
            name='avg_heart_rate',
            field=models.IntegerField(default=154, null=True),
        ),
    ]
