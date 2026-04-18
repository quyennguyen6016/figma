from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    ROLE_CHOICES = (('patient', 'patient'), ('doctor', 'doctor'))
    GENDER_CHOICES = (('male', 'male'), ('female', 'female'), ('other', 'other'))

    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='patient')
    full_name = models.CharField(max_length=255, blank=True)
    date_of_birth = models.DateField(null=True, blank=True)
    gender = models.CharField(max_length=20, choices=GENDER_CHOICES, blank=True)
    phone_number = models.CharField(max_length=20, blank=True)
    insurance_number = models.CharField(max_length=50, blank=True)
    address = models.CharField(max_length=255, blank=True)
