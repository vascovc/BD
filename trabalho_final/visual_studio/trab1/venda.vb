Public Class venda

    Private _num_venda As String
    Private _metodo_pagamento As String
    Private _data_registo As String
    Private _cliente As String
    Private _balcao As String
    Private _funcionario As String




    Property Num_venda() As String
        Get
            Num_venda = _num_venda
        End Get
        Set(ByVal value As String)
            _num_venda = value
        End Set
    End Property



    Property Metodo_pagamento() As String
        Get
            Metodo_pagamento = _metodo_pagamento
        End Get
        Set(ByVal value As String)
            If value Is Nothing Or value = "" Then
                Throw New Exception("Metodo de pagamento não pode ser vazio")
                Exit Property
            End If
            _metodo_pagamento = value
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

    Public Sub New(ByVal Num_venda As String, ByVal Metodo_pagamento As String, ByVal Data_registo As String, ByVal Cliente As String,
                   ByVal Balcao As String, ByVal Funcionario As String)
        MyBase.New
        Me.Num_venda = Num_venda
        Me.Metodo_pagamento = Metodo_pagamento
        Me.Data_registo = Data_registo
        Me.Cliente = Cliente
        Me.Balcao = Balcao
        Me.Funcionario = Funcionario
    End Sub




End Class
