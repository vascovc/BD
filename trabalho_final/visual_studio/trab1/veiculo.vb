<Serializable()> Public Class Veiculo
    Private _vin As String
    Private _marca As String
    Private _modelo As String
    Private _matricula As String
    Private _seguro As String
    Private _km As String
    Private _ano As String
    Private _combustivel As String
    Private _hp As String
    Private _localizacao As String
    Private _transmissao As String
    Private _estado As String

    Property Vin() As String
        Get
            Vin = _vin
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("VIN não pode ser vazio")
                Exit Property
            End If
            _vin = value
        End Set
    End Property
    Property Marca() As String
        Get
            Marca = _marca
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Marca nao pode ser vazio")
                Exit Property
            End If
            _marca = value
        End Set
    End Property

    Property Modelo() As String
        Get
            Modelo = _modelo
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("A inserir sem modelo")
                Exit Property
            End If
            _modelo = value
        End Set
    End Property

    Property Matricula() As String
        Get
            Matricula = _matricula
        End Get
        Set(ByVal value As String)
            _matricula = value
        End Set
    End Property

    Property Seguro() As String
        Get
            Seguro = _seguro
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Seguro não pode ser vazio")
                Exit Property
            End If
            _seguro = value
        End Set
    End Property

    Property Km() As String
        Get
            Km = _km
        End Get
        Set(ByVal value As String)
            _km = value
        End Set
    End Property

    Property Ano() As String
        Get
            Ano = _ano
        End Get
        Set(ByVal value As String)
            _ano = value
        End Set
    End Property
    Property Combustivel() As String
        Get
            Combustivel = _combustivel
        End Get
        Set(ByVal value As String)
            _combustivel = value
            Select Case value
                Case "1"
                    _combustivel = "Gasolina"
                Case "2"
                    _combustivel = "Gasoleo"
                Case "3"
                    _combustivel = "Eletrico"
                Case "4"
                    _combustivel = "GPL"
                Case "5"
                    _combustivel = "Hybrid"
            End Select
        End Set
    End Property
    Property Hp() As String
        Get
            Hp = _hp
        End Get
        Set(ByVal value As String)
            _hp = value
        End Set
    End Property

    Property Localizacao() As String
        Get
            Localizacao = _localizacao
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Localizacao não pode ser vazio")
                Exit Property
            End If
            _localizacao = value
        End Set
    End Property

    Property Transmissao() As String
        Get
            Transmissao = _transmissao
        End Get
        Set(ByVal value As String)
            _transmissao = value
            Select Case value
                Case "1"
                    _transmissao = "Manual"
                Case "2"
                    _transmissao = "Automatico"
            End Select
        End Set
    End Property
    Property Estado() As String
        Get
            Estado = _estado
        End Get
        Set(ByVal value As String)
            _estado = value
        End Set
    End Property

    Overrides Function ToString() As String
        Return _matricula & "  " & _marca & ", " & _modelo
    End Function

End Class

<Serializable()> Public Class Veiculo_aluguer
    Inherits Veiculo
    Private _limit_km_dia As String
    Private _preco_dia As String

    Property Limit_km_dia() As String
        Get
            Limit_km_dia = _limit_km_dia
        End Get
        Set(ByVal value As String)
            _limit_km_dia = value
        End Set
    End Property
    Property Preco_dia() As String
        Get
            Preco_dia = _preco_dia
        End Get
        Set(ByVal value As String)
            _preco_dia = value
        End Set
    End Property

    Public Sub New()
        MyBase.New()
    End Sub

    Public Sub New(ByVal Vin As String, ByVal Marca As String, ByVal Modelo As String, ByVal Matricula As String, ByVal Seguro As String, ByVal Km As String,
                   ByVal Ano As String, ByVal Combustivel As String, ByVal Hp As String, ByVal Localizacao As String, ByVal Estado As String)
        MyBase.New()
        Me.Vin = Vin
        Me.Marca = Marca
        Me.Modelo = Modelo
        Me.Matricula = Matricula
        Me.Seguro = Seguro
        Me.Km = Km
        Me.Ano = Ano
        Me.Combustivel = Combustivel
        Me.Hp = Hp
        Me.Localizacao = Localizacao
        Me.Estado = Estado
    End Sub

End Class

<Serializable()> Public Class Veiculo_venda
    Inherits Veiculo
    Private _valor_comercial As String

    Property Valor_comercial() As String
        Get
            Valor_comercial = _valor_comercial
        End Get
        Set(ByVal value As String)
            _valor_comercial = value
        End Set
    End Property
End Class