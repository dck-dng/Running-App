# Generated by Django 3.2.7 on 2024-04-05 06:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('activity', '0012_auto_20240404_1306'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='activityrecord',
            options={'ordering': ['-completed_at']},
        ),
        migrations.AlterField(
            model_name='activityrecord',
            name='avg_heart_rate',
            field=models.IntegerField(default=146, null=True),
        ),
    ]
