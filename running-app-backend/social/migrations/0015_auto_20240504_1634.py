# Generated by Django 3.2.7 on 2024-05-04 09:34

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('social', '0014_alter_follow_options'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='activityrecordpostlike',
            options={'ordering': ('-created_at',)},
        ),
        migrations.AlterModelOptions(
            name='clubpostlike',
            options={'ordering': ('-created_at',)},
        ),
        migrations.AlterModelOptions(
            name='eventpostlike',
            options={'ordering': ('-created_at',)},
        ),
    ]