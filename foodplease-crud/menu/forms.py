from django import forms

from .models import Producto


class ProductoForm(forms.ModelForm):
    class Meta:
        model = Producto

        fields = [
            "codigo",
            "nombre",
            "descripcion",
            "categoria",
            "precio",
            "stock",
        ]

        widgets = {
            "codigo": forms.TextInput(
                attrs={
                    "class": "form-control",
                    "placeholder": "Ejemplo: PIZ001",
                }
            ),
            "nombre": forms.TextInput(
                attrs={
                    "class": "form-control",
                    "placeholder": "Nombre del producto",
                }
            ),
            "descripcion": forms.Textarea(
                attrs={
                    "class": "form-control",
                    "placeholder": "Descripción o ingredientes",
                    "rows": 3,
                }
            ),
            "categoria": forms.Select(
                attrs={
                    "class": "form-select",
                }
            ),
            "precio": forms.NumberInput(
                attrs={
                    "class": "form-control",
                    "min": 500,
                    "step": 100,
                    "placeholder": "Ejemplo: 4990",
                }
            ),
            "stock": forms.NumberInput(
                attrs={
                    "class": "form-control",
                    "min": 0,
                    "step": 1,
                }
            ),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        if self.instance and self.instance.pk:
            self.fields["codigo"].disabled = True
            self.fields["codigo"].help_text = (
                "El código identifica al producto y no puede modificarse."
            )

    def clean_codigo(self):
        codigo = self.cleaned_data["codigo"].strip().upper()

        if not codigo:
            raise forms.ValidationError(
                "El código del producto es obligatorio."
            )

        return codigo

    def clean_nombre(self):
        nombre = self.cleaned_data["nombre"].strip()

        if len(nombre) < 3:
            raise forms.ValidationError(
                "El nombre debe contener al menos 3 caracteres."
            )

        return nombre