# Generated by Django 3.2.7 on 2024-04-12 02:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('account', '0009_auto_20240409_2018'),
    ]

    operations = [
        migrations.AlterField(
            model_name='profile',
            name='gender',
            field=models.CharField(choices=[('MALE', 'male'), ('FEMALE', 'female')], default='MALE', max_length=10),
        ),
        migrations.AlterField(
            model_name='profile',
            name='shirt_size',
            field=models.CharField(blank=True, choices=[('XS', 'extra small'), ('S', 'small'), ('M', 'medium'), ('L', 'large'), ('XL', 'extra large'), ('XXL', 'extra extra large')], max_length=10, null=True),
        ),
        migrations.AlterField(
            model_name='profile',
            name='trouser_size',
            field=models.CharField(blank=True, choices=[('XS', 'extra small'), ('S', 'small'), ('M', 'medium'), ('L', 'large'), ('XL', 'extra large'), ('XXL', 'extra extra large')], max_length=10, null=True),
        ),
    ]
