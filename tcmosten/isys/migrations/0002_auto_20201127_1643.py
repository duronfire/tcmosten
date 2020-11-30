# Generated by Django 3.1.1 on 2020-11-27 15:43

import datetime
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('isys', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='dummy',
            name='end',
            field=models.DateTimeField(default=datetime.datetime(2020, 11, 27, 16, 43, 18, 748449)),
        ),
        migrations.AlterField(
            model_name='dummy',
            name='start',
            field=models.DateTimeField(default=datetime.datetime(2020, 11, 27, 16, 43, 18, 748449)),
        ),
        migrations.AlterField(
            model_name='invoice',
            name='lastbill',
            field=models.DateTimeField(default=datetime.datetime(2020, 11, 27, 16, 43, 18, 768675)),
        ),
        migrations.AlterField(
            model_name='meeting',
            name='lastbill',
            field=models.DateTimeField(default=datetime.datetime(2020, 11, 27, 16, 43, 18, 769689)),
        ),
        migrations.AlterField(
            model_name='meeting',
            name='start',
            field=models.DateTimeField(default=datetime.datetime(2020, 11, 27, 16, 43, 18, 769689)),
        ),
        migrations.AlterField(
            model_name='therapist',
            name='Gender',
            field=models.CharField(choices=[('M', 'männlich'), ('W', 'weiblich')], default='SG', max_length=30),
        ),
    ]
