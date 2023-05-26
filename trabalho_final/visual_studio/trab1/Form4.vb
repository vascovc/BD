Imports System.IO
Imports System.Runtime.Serialization.Formatters.Binary
Imports System.Data.SqlClient
Public Class Form4
    Dim CN As SqlConnection
    Dim CMD As SqlCommand
    Private Sub Form4_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.WindowState = FormWindowState.Maximized
        CN = New SqlConnection("data source=VASCO-FIXO\TEW_SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = New SqlConnection("data source=VASCO\TEW_SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = New SqlConnection("data source=LAPTOP-GECIRST1\SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = Form1.connect_to_bd()
        CMD = New SqlCommand
        CMD.Connection = CN

        load_balcao()
        clientes_algueres()
        lucro_cliente()
        func_lucro_mes()
        balcao_veiculo()
    End Sub

    Private Sub AluguerToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles AluguerToolStripMenuItem.Click
        Form1.Show()
        Me.Hide()
    End Sub
    Private Sub CompraEVendaToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CompraEVendaToolStripMenuItem.Click
        Form2.Show()
        Me.Hide()
    End Sub
    Private Sub RegistarToolStripMenuItem_Click_1(sender As Object, e As EventArgs) Handles RegistarToolStripMenuItem.Click
        Form3.Show()
        Me.Hide()
    End Sub
    Private Sub SairToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles SairToolStripMenuItem.Click
        End
    End Sub

    Private Sub load_balcao()
        CMD.CommandText = "exec p_balcao"
        CMD.Parameters.Clear()
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox1.Items.Clear() 'balcao
        ComboBox1.Items.Add("")
        While RDR.Read
            Dim b As New Balcao
            b.Numero = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("numero")), "", RDR.Item("numero")))
            ComboBox1.Items.Add(b.Numero)
        End While
        CN.Close()
    End Sub
    Private Sub clientes_algueres()
        CMD.CommandText = "exec p_num_alug_clientes"
        CMD.Parameters.Clear()
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ListBox1.Items.Clear()
        Dim c As New Cliente
        Dim num As String
        While RDR.Read
            c.Num_cliente = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_cliente")), "", RDR.Item("num_cliente")))
            num = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_total_alug")), "", RDR.Item("num_total_alug")))
            ListBox1.Items.Add(c.Num_cliente & " -> " & num)
        End While
        CN.Close()
    End Sub

    Private Sub lucro_cliente()
        CMD.CommandText = "exec p_lucro_cliente"
        CMD.Parameters.Clear()
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ListBox2.Items.Clear()
        Dim c As New Cliente
        Dim num As String
        While RDR.Read
            c.Num_cliente = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_cliente")), "", RDR.Item("num_cliente")))
            num = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("valor")), "", RDR.Item("valor")))
            ListBox2.Items.Add(c.Num_cliente & " -> " & num)
        End While
        CN.Close()
    End Sub

    Private Sub balcao_veiculo()
        CMD.CommandText = "exec p_balcao_veiculo_alug"
        CMD.Parameters.Clear()
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ListBox3.Items.Clear()
        Dim b As New Balcao
        Dim v As New Veiculo
        Dim numero_alugueres As String
        Dim dias As String
        While RDR.Read
            b.Numero = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("balcao")), "", RDR.Item("balcao")))
            v.Marca = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("marca")), "", RDR.Item("marca")))
            v.Modelo = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("modelo")), "", RDR.Item("modelo")))
            numero_alugueres = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("numero_alugueres")), "", RDR.Item("numero_alugueres")))
            dias = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("avg_dias")), "", RDR.Item("avg_dias")))
            ListBox3.Items.Add(b.Numero & " -> " & v.Marca & "; " & v.Modelo & "->" & numero_alugueres & "; " & dias)
        End While
        CN.Close()
    End Sub

    Private Sub func_lucro_mes()

        Dim b As New Balcao
        b.Numero = ComboBox1.Text

        CMD.CommandText = "exec p_func_vendas @balcao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@balcao", b.Numero)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ListBox4.Items.Clear()
        Dim f As New Funcionario
        Dim ano As String
        Dim mes As String
        Dim num_vendas As String
        Dim lucro_das_vendas As String
        While RDR.Read
            f.Num_empregado = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_empregado")), "", RDR.Item("num_empregado")))
            ano = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("ano")), "", RDR.Item("ano")))
            mes = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("mes")), "", RDR.Item("mes")))
            num_vendas = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_vendas")), "", RDR.Item("num_vendas")))
            lucro_das_vendas = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("lucro_das_vendas")), "", RDR.Item("lucro_das_vendas")))
            ListBox4.Items.Add(ano & "; " & mes & " -> " & f.Num_empregado & " -> " & num_vendas & " -> " & lucro_das_vendas)
        End While
        CN.Close()
    End Sub

End Class