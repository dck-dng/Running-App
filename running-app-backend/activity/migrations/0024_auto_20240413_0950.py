# Generated by Django 3.2.7 on 2024-04-13 02:50

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('activity', '0023_auto_20240413_0947'),
    ]

    operations = [
        migrations.AlterField(
            model_name='activityrecord',
            name='avg_heart_rate',
            field=models.IntegerField(default=118, null=True),
        ),
        migrations.AlterField(
            model_name='activityrecord',
            name='title',
            field=models.CharField(default='', max_length=100),
        ),
    ]
