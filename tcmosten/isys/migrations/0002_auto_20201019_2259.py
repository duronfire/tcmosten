# Generated by Django 3.1.1 on 2020-10-19 20:59

import datetime
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('isys', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='dummy',
            name='end',
            field=models.DateTimeField(default=datetime.datetime(2020, 10, 19, 20, 59, 9, 580687, tzinfo=utc)),
        ),
        migrations.AddField(
            model_name='dummy',
            name='start',
            field=models.DateTimeField(default=datetime.datetime(2020, 10, 19, 20, 59, 9, 580687, tzinfo=utc)),
        ),
    ]