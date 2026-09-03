from decimal import Decimal, InvalidOperation

from django import template


register = template.Library()


@register.filter
def precio_clp(valor):
    """
    Convierte un valor numérico al formato monetario chileno.

    Ejemplos:
    3400 -> $3.400
    12500 -> $12.500
    """
    try:
        numero = Decimal(valor)
    except (InvalidOperation, TypeError, ValueError):
        return "$0"

    numero_entero = int(numero)

    precio_formateado = f"{numero_entero:,}".replace(",", ".")

    return f"${precio_formateado}"