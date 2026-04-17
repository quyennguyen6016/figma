from django.contrib.auth import get_user_model
from rest_framework import serializers


class RegisterSerializer(serializers.ModelSerializer):
    full_name = serializers.CharField(required=True)

    class Meta:
        model = get_user_model()
        fields = (
            'username',
            'password',
            'role',
            'full_name',
            'date_of_birth',
            'gender',
            'phone_number',
            'insurance_number',
            'address',
        )
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        password = validated_data.pop('password')
        user = get_user_model().objects.create_user(password=password, **validated_data)
        return user


class UserSerializer(serializers.ModelSerializer):
    date_of_birth = serializers.DateField(required=False, allow_null=True)

    class Meta:
        model = get_user_model()
        fields = (
            'id',
            'username',
            'role',
            'full_name',
            'date_of_birth',
            'gender',
            'phone_number',
            'insurance_number',
            'address',
        )
