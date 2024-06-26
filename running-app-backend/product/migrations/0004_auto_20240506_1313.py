# Generated by Django 3.2.7 on 2024-05-06 06:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('account', '0017_auto_20240505_1038'),
        ('product', '0003_alter_userproduct_id'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='userproduct',
            unique_together={('user', 'product')},
        ),
        migrations.AddIndex(
            model_name='userproduct',
            index=models.Index(fields=['user', 'product'], name='product_use_user_id_847271_idx'),
        ),
    ]
