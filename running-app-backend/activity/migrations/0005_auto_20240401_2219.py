# Generated by Django 3.2.7 on 2024-04-01 15:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('activity', '0004_auto_20240401_2201'),
    ]

    operations = [
        migrations.AddField(
            model_name='group',
            name='privacy',
            field=models.CharField(choices=[('PUBLIC', 'Public'), ('PRIVATE', 'Private')], default='PUBLIC', max_length=15),
        ),
        migrations.AddField(
            model_name='userparticipationgroup',
            name='is_admin',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='userparticipationgroup',
            name='is_approved',
            field=models.BooleanField(default=True),
        ),
    ]