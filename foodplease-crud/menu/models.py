from django.core.validators import MinValueValidator
from django.db import models


class Producto(models.Model):
    class Categoria(models.TextChoices):
        HAMBURGUESA = "hamburguesa", "Hamburguesa"
        PIZZA = "pizza", "Pizza"
        COMPLETO = "completo", "Completo"
        ACOMPANAMIENTO = "acompanamiento", "Acompañamiento"
        BEBIDA = "bebida", "Bebida"
        POSTRE = "postre", "Postre"
        OTRO = "otro", "Otro"

    codigo = models.CharField(
        max_length=20,
        unique=True,
        verbose_name="Código",
    )

    nombre = models.CharField(
        max_length=100,
        verbose_name="Nombre",
    )

    descripcion = models.TextField(
        max_length=500,
        blank=True,
        verbose_name="Descripción",
    )

    categoria = models.CharField(
        max_length=20,
        choices=Categoria.choices,
        default=Categoria.OTRO,
        verbose_name="Categoría",
    )

    precio = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        validators=[
            MinValueValidator(
                500,
                message="El precio mínimo permitido es $500.",
            )
        ],
        verbose_name="Precio",
    )

    stock = models.PositiveIntegerField(
        default=0,
        verbose_name="Stock",
    )

    disponible = models.BooleanField(
        default=True,
        verbose_name="Disponible",
    )

    fecha_creacion = models.DateTimeField(
        auto_now_add=True,
        verbose_name="Fecha de creación",
    )

    fecha_actualizacion = models.DateTimeField(
        auto_now=True,
        verbose_name="Última actualización",
    )

    class Meta:
        ordering = ["nombre"]
        verbose_name = "Producto"
        verbose_name_plural = "Productos"

    def save(self, *args, **kwargs):
        self.disponible = self.stock > 0
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.codigo} - {self.nombre}"


class Pedido(models.Model):
    class MetodoPago(models.TextChoices):
        TARJETA = "Tarjeta", "Tarjeta"
        EFECTIVO = "Efectivo", "Efectivo"

    class Estado(models.TextChoices):
        CONFIRMADO = "confirmado", "Pedido confirmado"
        PREPARACION = "preparacion", "En preparación"
        EN_CAMINO = "en_camino", "En camino"
        ENTREGADO = "entregado", "Entregado"

    direccion = models.CharField(
        max_length=255,
        verbose_name="Dirección de entrega",
    )

    metodo_pago = models.CharField(
        max_length=20,
        choices=MetodoPago.choices,
        verbose_name="Método de pago",
    )

    subtotal = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        validators=[MinValueValidator(0)],
        verbose_name="Subtotal",
    )

    costo_envio = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        default=2990,
        validators=[MinValueValidator(0)],
        verbose_name="Costo de envío",
    )

    descuento = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        default=0,
        validators=[MinValueValidator(0)],
        verbose_name="Descuento",
    )

    total = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        validators=[MinValueValidator(0)],
        verbose_name="Total",
    )

    estado = models.CharField(
        max_length=20,
        choices=Estado.choices,
        default=Estado.CONFIRMADO,
        verbose_name="Estado",
    )

    fecha_creacion = models.DateTimeField(
        auto_now_add=True,
        verbose_name="Fecha del pedido",
    )

    @property
    def numero(self):
        if self.pk:
            return f"FP-{self.pk:05d}"
        return "FP-PENDIENTE"

    class Meta:
        ordering = ["-fecha_creacion"]
        verbose_name = "Pedido"
        verbose_name_plural = "Pedidos"

    def __str__(self):
        return self.numero


class DetallePedido(models.Model):
    pedido = models.ForeignKey(
        Pedido,
        on_delete=models.CASCADE,
        related_name="detalles",
        verbose_name="Pedido",
    )

    producto = models.ForeignKey(
        Producto,
        on_delete=models.PROTECT,
        related_name="detalles_pedido",
        verbose_name="Producto",
    )

    cantidad = models.PositiveIntegerField(
        validators=[MinValueValidator(1)],
        verbose_name="Cantidad",
    )

    precio_unitario = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        validators=[MinValueValidator(0)],
        verbose_name="Precio unitario",
    )

    @property
    def subtotal(self):
        return self.precio_unitario * self.cantidad

    class Meta:
        verbose_name = "Detalle de pedido"
        verbose_name_plural = "Detalles de pedido"

    def __str__(self):
        return (
            f"{self.pedido.numero} - "
            f"{self.producto.nombre} x {self.cantidad}"
        )