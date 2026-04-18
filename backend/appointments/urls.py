from django.urls import path

from .views import appointment_list_create, appointment_update_delete

urlpatterns = [
    path('appointments/', appointment_list_create, name='appointments-list-create'),
    path('appointments/<str:pk>/', appointment_update_delete, name='appointments-update-delete'),
]
