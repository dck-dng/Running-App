# Generated by Django 3.2.7 on 2024-05-03 04:26

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('social', '0012_auto_20240503_1125'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='activityrecordpostcomment',
            unique_together=set(),
        ),
        migrations.AlterUniqueTogether(
            name='clubpostcomment',
            unique_together=set(),
        ),
        migrations.AlterUniqueTogether(
            name='eventpostcomment',
            unique_together=set(),
        ),
    ]
