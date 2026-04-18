from django.urls import path

from .views import login_view, logout_view, me_view, register_view, users_view

urlpatterns = [
    path('auth/register/', register_view, name='auth-register'),
    path('auth/login/', login_view, name='auth-login'),
    path('auth/me/', me_view, name='auth-me'),
    path('auth/logout/', logout_view, name='auth-logout'),
    path('users/', users_view, name='users-list'),
]
