from django import forms
from .models import course, academic_term, faq, SupportTicket
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
    category = forms.ChoiceField(
        choices= faq.CATEGORY_CHOICES,
        required=True, 
        widget=forms.HiddenInput(),
    )
    class Meta:
        model = faq
        fields = ['title', 'content', 'category', 'is_ad_visible', 'is_lc_visible', 'is_tp_visible', 'is_visitor_visible']
        widgets = {
            'title': forms.TextInput(attrs={
                'class' : 'form-control',
                'placeholder': ' '
                }),
            'content': forms.HiddenInput(attrs={'required': True}),
            'category' : forms.HiddenInput(attrs={'required': True}),
            'is_visitor_visible': forms.HiddenInput(attrs={'required': True}),
            'is_ad_visible': forms.HiddenInput(attrs={'required': True}),
            'is_lc_visible': forms.HiddenInput(attrs={'required': True}),
            'is_tp_visible': forms.HiddenInput(attrs={'required': True}),
        }



class LimitedMultipleFileField(forms.FileField):
    def __init__(self, max_files = 5, max_file_size = 10 * 1024 * 1024, *args, **kwargs):
        self.max_files = max_files
        self.max_file_size = max_files
        kwargs.setdefault("widget", MultipleFileInput())
        super().__init__(*args, **kwargs)
    
    def clean(self, data, initial=None):
        single_file_clean = super().clean
        if isinstance(data, (list, tuple())):
            if len(data) > self.max_files:
                raise forms.ValidationError(f"You can upload up to {self.max_files} files only.")
            result = [single_file_clean(d, initial) for d in data]
            for file in result: 
                if file.size > self.max_file_size:
                    raise forms.ValidationError(f"File size should not exceed {self.max_file_size} bytes.")
        else:
            result = single_file_clean(data, initial)
        return result

class SupportTicketForm(forms.ModelForm):
    extra_attachments = LimitedMultipleFileField()

    class Meta:
        model = SupportTicket
        fields = ['category', 'title', 'description', 'extra_attachments']
        widgets = {
            'title': forms.TextInput(attrs={
                'class': 'form-control', 
                'placeholder': 'Enter a brief title'
            }),
            'category': forms.Select(attrs={'class': 'form-control'}),
            'description': forms.Textarea(attrs={
                'class': 'form-control', 
                'placeholder': 'Describe your issue in detail...',
                'id': 'ticket-editor' 
            }),
        }

    def clean_extra_attachments(self):
        """Optional: Add validation for file sizes or types here."""
        files = self.files.getlist('extra_attachments')
        for f in files:
            if f.size > 10 * 1024 * 1024: 
                raise forms.ValidationError(f"File {f.name} is too large. Max size is 10MB.")
        return files