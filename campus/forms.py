from django import forms
from .models import course, academic_term, faq
from django.contrib.auth.forms import AuthenticationForm, SetPasswordForm, PasswordResetForm

class CustomLoginForm(AuthenticationForm):
    username = forms.EmailField(widget=forms.EmailInput(attrs={
        'placeholder': ' ',
        'autofocus': True,
    }))
    password = forms.CharField(widget=forms.PasswordInput(attrs={
        'placeholder': ' ',
    }))

    remember_me = forms.BooleanField(required=False, initial=False, widget=forms.CheckboxInput())

class CustomPasswordResetForm(PasswordResetForm):
    email = forms.EmailField(widget=forms.EmailInput(attrs={
        'placeholder': ' ',
    }))

class CustomSetPasswordForm(SetPasswordForm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.fields["new_password1"].widget.attrs.update({
            "placeholder": " ",
        })
        self.fields["new_password2"].widget.attrs.update({
            "placeholder": " ",
        })

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
    department = forms.CharField(widget=forms.HiddenInput())

    #student
    term = forms.CharField(widget=forms.HiddenInput(), required=False)

    def clean(self):
        cleaned_data = super().clean()
        role = cleaned_data.get("user_role")

        # Validation Logic based on Role
        if role == "3":
            if not cleaned_data.get("term"):
                self.add_error('term', "Academic Term is required for students.")
            
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

class newFAQForm(forms.ModelForm):
    class Meta:
        model = faq
        fields = ['title', 'content', 'category', 'is_published']
        widgets = {
            'title': forms.TextInput(attrs={
                'class' : 'form-control',
                'placeholder': ''
                }),
            'content': forms.HiddenInput(),
            'category' : forms.HiddenInput(),
            'is_published': forms.HiddenInput(),
        }