<Serializable()> Public Class Aluguer
    Private _num_aluguer As String
    Private _data_registo As String
    Private _data_fim As String
    Private _cliente As String
    Private _alug_balc As String
    Private _veiculo As String

    Property Num_aluguer() As String
        Get
            Num_aluguer = _num_aluguer
        End Get
        Set(ByVal value As String)
            _num_aluguer = value
        End Set
    End Property
    Property Data_registo() As String
        Get
            Data_registo = _data_registo
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Data registo não pode ser vazio")
                Exit Property
            End If
            _data_registo = value
        End Set
    End Property
    Property Data_fim() As String
        Get
            Data_fim = _data_fim
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Data fim não pode ser vazio")
                Exit Property
            End If
            _data_fim = value
        End Set
    End Property
    Property Cliente() As String
        Get
            Cliente = _cliente
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Cliente não pode ser vazio")
                Exit Property
            End If
            _cliente = value
        End Set
    End Property
    Property Alug_balc() As String
        Get
            Alug_balc = _alug_balc
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Balcao não pode ser vazio")
                Exit Property
            End If
            _alug_balc = value
        End Set
    End Property
    Property Veiculo() As String
        Get
            Veiculo = _veiculo
        End Get
        Set(ByVal value As String)
            _veiculo = value
        End Set
    End Property
    Overrides Function ToString() As String
        Return _num_aluguer
    End Function
    Public Sub New()
        MyBase.New()
    End Sub

    Public Sub New(ByVal Num_alguer As String, ByVal Data_registo As String, ByVal Data_fim As String, ByVal Cliente As String,
                   ByVal Alug_balc As String, ByVal Veiculo As String)
        MyBase.New
        Me.Num_aluguer = Num_alguer
        Me.Data_registo = Data_registo
        Me.Data_fim = Data_fim
        Me.Cliente = Cliente
        Me.Alug_balc = Alug_balc
        Me.Veiculo = Veiculo
    End Sub


End Class

<Serializable()> Public Class Log
    Inherits Aluguer
    Private _danos As String
    Private _data As String
    Private _taxa As String
    Private _km_feitos As String
    Private _drop_off As String
    Private _funcionario As String

    Property Danos() As String
        Get
            Danos = _danos
        End Get
        Set(ByVal value As String)
            _danos = value
        End Set
    End Property
    Property Data() As String
        Get
            Data = _data
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Data não pode ser vazio")
                Exit Property
            End If
            _data = value
        End Set
    End Property
    Property Taxa() As String
        Get
            Taxa = _taxa
        End Get
        Set(ByVal value As String)
            _taxa = value
            If value Is Nothing Or value = "" Then
                _taxa = "0"
            End If
        End Set
    End Property
    Property Km_feitos() As String
        Get
            Km_feitos = _km_feitos
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Quilometros agora não pode ser vazio")
                Exit Property
            End If
            _km_feitos = value
        End Set
    End Property

    Property Drop_off() As String
        Get
            Drop_off = _drop_off
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Balcao de entrega não pode ser vazio")
                Exit Property
            End If
            _drop_off = value
        End Set
    End Property

    Property Funcionario() As String
        Get
            Funcionario = _funcionario
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Funcionario que aceita o veiculo não pode ser vazio")
                Exit Property
            End If
            _funcionario = value
        End Set
    End Property

    Public Sub New()
        MyBase.New()
    End Sub

    Public Sub New(ByVal Danos As String, Data As String, Taxa As String, Km_feitos As String, Drop_off As String, Funcionario As String)
        Me._danos = Danos
        Me._data = Data
        Me._taxa = Taxa
        Me._km_feitos = Km_feitos
        Me._drop_off = Drop_off
        Me._funcionario = Funcionario

    End Sub

End Class

