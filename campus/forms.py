from django import forms
from .models import course, academic_term, departments

class LoginForm(forms.Form):
    # Defining the fields that will appear in {{ form.as_p }}
    email = forms.EmailField(
        widget=forms.EmailInput(attrs={'placeholder': 'Email Address', 'class': 'input-field'})
    )
    password = forms.CharField(
        widget=forms.PasswordInput(attrs={'placeholder': 'Password', 'class': 'input-field'})
    )

class PasswordResetRequestForm(forms.Form):
    email = forms.EmailField(
        widget=forms.EmailInput(attrs={'placeholder': 'Email Address', 'class': 'input-field'})
    )

class PasscordVerificationForm(forms.Form):
    passcode = forms.CharField(
        max_length=6,
        min_length=6,
        widget=forms.HiddenInput()
    )

class SetNewPasswordForm(forms.Form):
    new_password = forms.CharField(
        widget=forms.PasswordInput(attrs={'placeholder': 'New Password', 'class': 'input-field'})
    )
    confirm_password = forms.CharField(
        widget=forms.PasswordInput(attrs={'placeholder': 'Confirm Password', 'class': 'input-field'})
    )

    def clean(self):
        cleaned_data = super().clean()
        new_password = cleaned_data.get("new_password")
        confirm_password = cleaned_data.get("confirm_password")

        if new_password and confirm_password:
            if new_password != confirm_password:
                raise forms.ValidationError("The new password and confirm password do not match.")
            
class UserRowForm(forms.Form):
    user_role = forms.CharField(widget=forms.HiddenInput())

    first_name = forms.CharField(
        max_length=100, widget=forms.TextInput(attrs={'placeholder': 'First Name'})
    )
    last_name = forms.CharField(
        max_length=100, widget=forms.TextInput(attrs={'placeholder': 'Last Name'})
    )
    email = forms.EmailField(
        widget=forms.EmailInput(attrs={'placeholder': 'Email'})
    )

    # for lecturer
    department = forms.HiddenInput()

    #student
    term = forms.HiddenInput()

    def clean(self):
        cleaned_data = super().clean()
        role = cleaned_data.get("user_role")

        # Validation Logic based on Role
        if role == "student":
            if not cleaned_data.get("term"):
                self.add_error('term', "Academic Term is required for students.")
        
        elif role == "lecturer":
            # Department is optional according to your requirements
            pass
            
        return cleaned_data

class AcademicTermForm(forms.ModelForm):
    level = forms.ChoiceField(
        choices= course.LEVEL_CHOICES,
        required=True, 
        widget=forms.HiddenInput(),
    )

    class Meta:
        model = academic_term
        fields = ['level', 'course', 'start_date', 'end_date']
        widgets = {
            'level': forms.HiddenInput(attrs={'required': True}),
            'course': forms.HiddenInput(attrs={'required': True}),
            'start_date': forms.TextInput(attrs={
                'class': 'form-control datepicker', 
                'placeholder': 'Select Start Date', 
                'readonly': 'readonly',
                'required' : True,
                }),
            'end_date': forms.TextInput(attrs={
                'class': 'form-control datepicker', 
                'readonly': 'readonly',
                'required' : True,
                }),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['course'].empty_label = "Please choose a course"
        self.fields['course'].queryset = course.objects.all()

    def clean(self):
        cleaned_data = super().clean()
        return cleaned_data