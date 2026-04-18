from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import User


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    fieldsets = UserAdmin.fieldsets + (
        ('Extra Info', {
            'fields': (
                'role',
                'full_name',
                'date_of_birth',
                'gender',
                'phone_number',
                'insurance_number',
                'address',
            )
        }),
    )
    list_display = ('username', 'email', 'role', 'is_staff', 'is_active')
