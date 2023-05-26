<Serializable()> Public Class Balcao
    Private _numero As String
    Private _gerente As String
    Private _localizacao As String

    Property Numero() As String
        Get
            Numero = _numero
        End Get
        Set(ByVal value As String)
            _numero = value
            'If value = "" Then
            'Throw New Exception("Numero balcao não pode ser vazio")
            'Exit Property
            'End If
        End Set
    End Property
    Property Gerente() As String
        Get
            Gerente = _gerente
        End Get
        Set(ByVal value As String)
            _gerente = value
            'If value = "" Then
            'Throw New Exception("Gerente não pode ser vazio")
            'Exit Property
            'End If
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
    Overrides Function ToString() As String
        Return _numero
    End Function
    Public Sub New()
        MyBase.New()
    End Sub

    Public Sub New(ByVal Numero As String, ByVal Gerente As String, ByVal Localizacao As String)
        MyBase.New()
        Me.Numero = Numero
        Me.Gerente = Gerente
        Me.Localizacao = Localizacao
    End Sub
End Class
