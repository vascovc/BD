Public Class Compra


    Private _num_compra As String
    Private _data As String
    Private _cliente As String
    Private _balcao As String
    Private _funcionario As String


    Property Num_compra() As String
        Get
            Num_compra = _num_compra
        End Get
        Set(ByVal value As String)
            _num_compra = value
        End Set
    End Property
    Property Data() As String
        Get
            Data = _data
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Data registo não pode ser vazio")
                Exit Property
            End If
            _data = value
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



    Property Balcao() As String
        Get
            Balcao = _balcao
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Balcão não pode ser vazio")
                Exit Property
            End If
            _balcao = value
        End Set
    End Property



    Property Funcionario() As String
        Get
            Funcionario = _funcionario
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Funcionário não pode ser vazio")
                Exit Property
            End If
            _funcionario = value
        End Set
    End Property



    Public Sub New()
        MyBase.New()
    End Sub

    Public Sub New(ByVal Num_compra As String, ByVal Data As String, ByVal Cliente As String,
                   ByVal Balcao As String, ByVal Funcionario As String)
        MyBase.New
        Me.Num_compra = Num_compra
        Me.Data = Data
        Me.Cliente = Cliente
        Me.Balcao = Balcao
        Me.Funcionario = Funcionario
    End Sub



End Class
