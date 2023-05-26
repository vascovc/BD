<Serializable()> Public Class Pessoa
    Private _nome As String
    Private _nif As String
    Private _morada As String
    Private _data_nascimento As String
    Private _telemovel As String

    Property Nome() As String
        Get
            Nome = _nome
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Nome não pode ser vazio")
                Exit Property
            End If
            _nome = value
        End Set
    End Property

    Property NIF() As String
        Get
            NIF = _nif
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("NIF não pode ser vazio")
                Exit Property
            End If
            _nif = value
        End Set
    End Property


    Property Data_nascimento() As String
        Get
            Data_nascimento = _data_nascimento
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Data de nascimento não pode ser vazio")
                Exit Property
            End If
            _data_nascimento = value
        End Set
    End Property

    Property Telemovel() As String
        Get
            Telemovel = _telemovel
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Telemovel não pode ser vazio")
                Exit Property
            End If
            _telemovel = value
        End Set
    End Property

    Property Morada() As String
        Get
            Morada = _morada
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Morada não pode ser vazio")
                Exit Property
            End If
            _morada = value
        End Set
    End Property

End Class

<Serializable()> Public Class Cliente
    Inherits Pessoa

    Private _email As String
    Private _num_cliente As String
    Private _carta As String

    Property Carta() As String
        Get
            Carta = _carta
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Carta não pode ser vazio")
                Exit Property
            End If
            _carta = value
        End Set
    End Property

    Property Num_cliente() As String
        Get
            Num_cliente = _num_cliente
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Numero de cliente não pode ser vazio")
                Exit Property
            End If
            _num_cliente = value
        End Set
    End Property

    Property Email() As String
        Get
            Email = _email
        End Get
        Set(ByVal value As String)
            _email = value
        End Set
    End Property

    Public Sub New()
        MyBase.New()
    End Sub

    Public Sub New(ByVal Nome As String, ByVal NIF As String, ByVal Carta As String, ByVal Email As String, ByVal Data_nascimento As Date, ByVal Morada As String, ByVal Telemovel As String, ByVal Num_cliente As String)
        MyBase.New()
        Me.Nome = Nome
        Me.NIF = NIF
        Me.Carta = Carta
        Me.Email = Email
        Me.Data_nascimento = Data_nascimento
        Me.Morada = Morada
        Me.Telemovel = Telemovel
        Me.Num_cliente = Num_cliente
    End Sub

End Class

<Serializable()> Public Class Funcionario
    Inherits Pessoa

    Private _email As String
    Private _num_empregado As String
    Private _carta As String
    Private _balcao As String

    Property Carta() As String
        Get
            Carta = _carta
        End Get
        Set(ByVal value As String)
            _carta = value
        End Set
    End Property

    Property Num_empregado() As String
        Get
            Num_empregado = _num_empregado
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Número de empregado não nulo")
                Exit Property
            End If
            _num_empregado = value
        End Set
    End Property

    Property Email() As String
        Get
            Email = _email
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Email de funcionário não pode ser nulo")
                Exit Property
            End If
            _email = value
        End Set
    End Property

    Property Balcao() As String
        Get
            Balcao = _balcao
        End Get
        Set(ByVal value As String) 'pode ser posto a null
            _balcao = value
        End Set
    End Property
    Public Sub New()
        MyBase.New()
    End Sub

    Public Sub New(ByVal Nome As String, ByVal NIF As String, ByVal Carta As String, ByVal Email As String, ByVal Data_nascimento As Date, ByVal Morada As String, ByVal Telemovel As String, ByVal Num_empregado As String, ByVal Balcao As String)
        MyBase.New()
        Me.Nome = Nome
        Me.NIF = NIF
        Me.Carta = Carta
        Me.Email = Email
        Me.Data_nascimento = Data_nascimento
        Me.Morada = Morada
        Me.Telemovel = Telemovel
        Me.Num_empregado = Num_empregado
        Me.Balcao = Balcao
    End Sub
End Class
