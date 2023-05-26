Imports System.IO
Imports System.Runtime.Serialization.Formatters.Binary
Imports System.Data.SqlClient
Public Class Form1
    Dim CN As SqlConnection
    Dim CMD As SqlCommand

    Dim currentVeiculo As Integer
    Dim currentAlug As Integer

    Dim var_marca As String
    Dim var_modelo As String
    Dim var_ano As String
    Dim var_combs As String
    Dim var_transm As String
    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.WindowState = FormWindowState.Maximized
        CN = New SqlConnection("data source=VASCO-FIXO\TEW_SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = New SqlConnection("data source=LAPTOP-GECIRST1\SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        Button1.Hide()
        Button5.Hide()

        CMD = New SqlCommand
        CMD.Connection = CN
        clean_apos_aluguer()
        read_alug()
    End Sub
    Private Sub SairToolStripMenuItem_Click_1(sender As Object, e As EventArgs) Handles SairToolStripMenuItem.Click
        End
    End Sub

    Private Sub VendaToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles VendaToolStripMenuItem.Click
        Form2.Show()
        Me.Hide()
    End Sub
    Private Sub RegistarClienteToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles RegistarClienteToolStripMenuItem.Click
        Form3.Show()
        Me.Hide()
    End Sub

    Private Sub EstatísticasToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles EstatísticasToolStripMenuItem.Click
        Form4.Show()
        Me.Hide()
    End Sub

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Form3.Show()
        Form3.TextBox1.Text = TextBox3.Text
        Form3.TextBox3.Text = TextBox4.Text
        Form3.TextBox2.Text = TextBox5.Text
        Form3.TextBox11.Text = TextBox6.Text
        Me.Hide()
    End Sub
    Public Function connect_to_bd() As SqlConnection
        'CN = New SqlConnection("data source=VASCO-FIXO\TEW_SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = New SqlConnection("data source=VASCO\TEW_SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = New SqlConnection("data source=LAPTOP-GECIRST1\SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        Return CN
    End Function

    Private Sub clean_apos_aluguer()
        var_marca = ""
        var_modelo = ""
        var_ano = ""
        var_combs = ""
        var_transm = ""
        load_veiculos()
        load_marcas()
        load_modelos()
        load_ano()
        load_transmissao()
        load_combustivel()
        load_balcao()
    End Sub
    Private Sub ListBox1_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ListBox1.SelectedIndexChanged
        If ListBox1.SelectedIndex > -1 Then
            currentVeiculo = ListBox1.SelectedIndex
            show_veiculo()
        End If
    End Sub

    Private Sub ComboBox1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox1.SelectedIndexChanged
        'marca
        If ComboBox1.SelectedIndex > -1 Then
            var_marca = ComboBox1.SelectedItem
            load_veiculos()
            load_modelos()
            load_ano()
            load_transmissao()
            load_combustivel()
            load_balcao()
        End If
    End Sub
    Private Sub ComboBox2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox2.SelectedIndexChanged
        'modelo
        If ComboBox2.SelectedIndex > -1 Then
            var_modelo = ComboBox2.SelectedItem
            load_veiculos()
            load_marcas()
            load_ano()
            load_transmissao()
            load_combustivel()
            load_balcao()
        End If
    End Sub
    Private Sub ComboBox4_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox4.SelectedIndexChanged
        'ano
        If ComboBox4.SelectedIndex > -1 Then
            var_ano = ComboBox4.SelectedItem
            load_marcas()
            load_modelos()
            load_transmissao()
            load_combustivel()
            load_veiculos()
            load_balcao()
        End If
    End Sub
    Private Sub ComboBox5_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox5.SelectedIndexChanged
        'combustivel
        If ComboBox5.SelectedIndex > -1 Then
            var_combs = ComboBox5.SelectedItem
            Select Case var_combs
                Case "Gasolina"
                    var_combs = "1"
                Case "Gasoleo"
                    var_combs = "2"
                Case "Eletrico"
                    var_combs = "3"
                Case "GPL"
                    var_combs = "4"
                Case "Hybrid"
                    var_combs = "5"
            End Select
            MessageBox.Show("var_combs: " & var_combs)
            load_marcas()
            load_ano()
            load_transmissao()
            load_modelos()
            load_veiculos()
            load_balcao()
        End If
    End Sub
    Private Sub ComboBox7_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox7.SelectedIndexChanged
        'transmissao
        If ComboBox7.SelectedIndex > -1 Then
            var_transm = ComboBox7.SelectedItem
            Select Case var_transm
                Case "Manual"
                    var_transm = "1"
                Case "Automatico"
                    var_transm = "2"
            End Select
            MessageBox.Show("var_transm: " & var_transm)
            load_veiculos()
            load_marcas()
            load_ano()
            load_combustivel()
            load_modelos()
            load_balcao()
        End If
    End Sub
    Private Sub ComboBox6_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox6.SelectedIndexChanged
        'balcao
        If ComboBox6.SelectedIndex > -1 Then
            load_marcas()
            load_ano()
            load_transmissao()
            load_modelos()
            load_veiculos()
        End If
    End Sub
    Private Sub load_marcas()
        CMD.CommandText = "exec p_marcas @var_modelo, @var_ano, @var_combs, @var_transm"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@var_modelo", var_modelo)
        CMD.Parameters.AddWithValue("@var_ano", var_ano)
        CMD.Parameters.AddWithValue("@var_combs", var_combs)
        CMD.Parameters.AddWithValue("@var_transm", var_transm)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox1.Items.Clear() 'marcas
        ComboBox1.Items.Add("")
        While RDR.Read
            Dim V As New Veiculo_aluguer
            V.Marca = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("marca")), "", RDR.Item("marca")))
            ComboBox1.Items.Add(V.Marca)
        End While
        CN.Close()
    End Sub
    Private Sub load_modelos()
        CMD.CommandText = "exec p_modelos @marca, @ano, @combs, @transmissao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@marca", var_marca)
        CMD.Parameters.AddWithValue("@ano", var_ano)
        CMD.Parameters.AddWithValue("@combs", var_combs)
        CMD.Parameters.AddWithValue("@transmissao", var_transm)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox2.Items.Clear() 'modelos
        ComboBox2.Items.Add("")
        While RDR.Read
            Dim V As New Veiculo_aluguer
            V.Modelo = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("modelo")), "", RDR.Item("modelo")))
            ComboBox2.Items.Add(V.Modelo)
        End While
        CN.Close()
    End Sub
    Private Sub load_ano()
        CMD.CommandText = "exec p_anos @marca, @modelo, @combs, @transmissao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@marca", var_marca)
        CMD.Parameters.AddWithValue("@modelo", var_modelo)
        CMD.Parameters.AddWithValue("@combs", var_combs)
        CMD.Parameters.AddWithValue("@transmissao", var_transm)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox4.Items.Clear() 'ano
        ComboBox4.Items.Add("")
        While RDR.Read
            Dim V As New Veiculo_aluguer
            V.Ano = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("ano")), "", RDR.Item("ano")))
            ComboBox4.Items.Add(V.Ano)
        End While
        CN.Close()
    End Sub
    Private Sub load_combustivel()
        CMD.CommandText = "exec p_combustivel @modelo, @marca, @ano, @transmissao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@modelo", var_modelo)
        CMD.Parameters.AddWithValue("@marca", var_marca)
        CMD.Parameters.AddWithValue("@ano", var_ano)
        CMD.Parameters.AddWithValue("@transmissao", var_transm)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox5.Items.Clear() 'combustivel
        ComboBox5.Items.Add("")
        While RDR.Read
            Dim V As New Veiculo_aluguer
            V.Combustivel = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("combustivel")), "", RDR.Item("combustivel")))

            ComboBox5.Items.Add(V.Combustivel)

        End While
        CN.Close()
    End Sub
    Private Sub load_transmissao()
        CMD.CommandText = "exec p_transmissao @modelo, @marca, @ano, @combustivel"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@modelo", var_modelo)
        CMD.Parameters.AddWithValue("@marca", var_marca)
        CMD.Parameters.AddWithValue("@ano", var_ano)
        CMD.Parameters.AddWithValue("@combustivel", var_combs)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox7.Items.Clear() 'modelos
        ComboBox7.Items.Add("")
        While RDR.Read
            Dim V As New Veiculo_aluguer
            V.Transmissao = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("transmissao")), "", RDR.Item("transmissao")))
            ComboBox7.Items.Add(V.Transmissao)
        End While
        CN.Close()
    End Sub
    Private Sub load_balcao()
        CMD.CommandText = "exec p_balcao"
        CMD.Parameters.Clear()
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox6.Items.Clear() 'balcao
        ComboBox6.Items.Add("")
        While RDR.Read
            Dim b As New Balcao
            b.Numero = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("numero")), "", RDR.Item("numero")))
            ComboBox6.Items.Add(b.Numero)
        End While
        CN.Close()
    End Sub
    Private Sub load_veiculos()
        Dim b As New Balcao
        b.Numero = ComboBox6.Text
        CMD.CommandText = "exec p_veiculos_aluguer @marca, @modelo, @ano, @combs, @transmissao, @localizacao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@marca", var_marca)
        CMD.Parameters.AddWithValue("@modelo", var_modelo)
        CMD.Parameters.AddWithValue("@ano", var_ano)
        CMD.Parameters.AddWithValue("@combs", var_combs)
        CMD.Parameters.AddWithValue("@transmissao", var_transm)
        CMD.Parameters.AddWithValue("@localizacao", b.Numero)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ListBox1.Items.Clear() 'pagina dos veiculos
        While RDR.Read
            Dim V As New Veiculo_aluguer
            V.Vin = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("vin")), "", RDR.Item("vin")))
            V.Marca = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("marca")), "", RDR.Item("marca")))
            V.Modelo = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("modelo")), "", RDR.Item("modelo")))
            V.Matricula = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("matricula")), "", RDR.Item("matricula")))
            V.Km = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("km")), "", RDR.Item("km")))
            V.Ano = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("ano")), "", RDR.Item("ano")))
            V.Hp = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("hp")), "", RDR.Item("hp")))
            V.Localizacao = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("localizacao")), "", RDR.Item("localizacao")))
            V.Limit_km_dia = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("limit_km_dia")), "", RDR.Item("limit_km_dia")))
            V.Preco_dia = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("preco_dia")), "", RDR.Item("preco_dia")))
            V.Combustivel = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("combustivel")), "", RDR.Item("combustivel")))
            V.Transmissao = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("transmissao")), "", RDR.Item("transmissao")))

            ListBox1.Items.Add(V)
        End While
        CN.Close()
        currentVeiculo = 0
        'ListBox1.SelectedIndex = 0
        show_veiculo()
    End Sub

    Sub show_veiculo()
        If ListBox1.Items.Count = 0 Or currentVeiculo < 0 Then Exit Sub
        Dim veiculo As New Veiculo_aluguer
        veiculo = CType(ListBox1.Items.Item(currentVeiculo), Veiculo)

        TextBox2.Text = veiculo.Hp
        TextBox1.Text = veiculo.Km
        TextBox15.Text = veiculo.Preco_dia
        TextBox16.Text = veiculo.Limit_km_dia
    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        currentVeiculo = ListBox1.SelectedIndex

        If currentVeiculo < 0 Then
            MsgBox("Selecione um veiculo")
            Exit Sub
        End If
        Dim veiculo As New Veiculo_aluguer
        veiculo = CType(ListBox1.Items.Item(currentVeiculo), Veiculo)
        Submit_aluguer(veiculo)
        read_alug()
    End Sub

    Private Sub Submit_aluguer(ByVal V As Veiculo_aluguer)
        Dim c As New Cliente
        Dim b As New Balcao
        Dim f As New Funcionario
        Dim a As New Aluguer
        Try
            c.Num_cliente = TextBox6.Text
            If ComboBox6.Text = "" Then
                b.Numero = V.Localizacao
            Else
                b.Numero = ComboBox6.Text
            End If

            f.Num_empregado = TextBox14.Text
            a.Data_fim = MonthCalendar1.SelectionEnd.Year & "-" & MonthCalendar1.SelectionEnd.Month & "-" & MonthCalendar1.SelectionEnd.Day
        Catch ex As Exception
            MessageBox.Show(ex.Message)
            Return
        End Try

        CMD.CommandText = "exec p_submit_aluguer @data_fim, @cliente, @alug_balc, @veiculo, @funcionario"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@data_fim", a.Data_fim)
        CMD.Parameters.AddWithValue("@cliente", c.Num_cliente)
        CMD.Parameters.AddWithValue("@alug_balc", b.Numero)
        CMD.Parameters.AddWithValue("@veiculo", V.Vin)
        CMD.Parameters.AddWithValue("@funcionario", f.Num_empregado)
        CN.Open()
        Try
            CMD.ExecuteNonQuery()
        Catch ex As Exception
            MessageBox.Show("Aluguer nao submetido. " & vbCrLf & "ERROR MESSAGE: " & vbCrLf & ex.Message)
            Return
        Finally
            CN.Close()
        End Try
        CN.Close()
        clean_apos_aluguer()
        clean_cliente()
        TextBox14.Text = ""
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        TextBox3.ReadOnly = True
        TextBox4.ReadOnly = True
        TextBox5.ReadOnly = True
        TextBox6.ReadOnly = True
        Dim c As New Cliente
        If TextBox4.Text = "" And TextBox5.Text = "" And TextBox6.Text = "" Then
            MessageBox.Show("Insira algum dado do cliente")
            clean_cliente()
            Return
        End If
        If TextBox4.Text <> "" Then
            c.Carta = TextBox4.Text
        End If
        If TextBox5.Text <> "" Then
            c.NIF = TextBox5.Text
        End If
        If TextBox6.Text <> "" Then
            c.Num_cliente = TextBox6.Text
        End If
        CMD.CommandText = "exec p_get_num_cliente @nif, @carta, @num_cliente"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@nif", TextBox5.Text) 'nao devia ser feito assim mas como se verifica antes passam se nulos
        CMD.Parameters.AddWithValue("@carta", TextBox4.Text.ToString)
        CMD.Parameters.AddWithValue("@num_cliente", TextBox6.Text.ToString)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        While RDR.Read
            c.Num_cliente = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_cliente")), "", RDR.Item("num_cliente")))
            c.Nome = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("nome")), "", RDR.Item("nome")))
            c.Carta = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_carta")), "", RDR.Item("num_carta")))
            c.NIF = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("nif")), "", RDR.Item("nif")))
        End While
        CN.Close()
        TextBox6.Text = c.Num_cliente
        TextBox5.Text = c.NIF
        TextBox4.Text = c.Carta
        TextBox3.Text = c.Nome

        If c.Nome <> "" Then
            Button1.Show()
        End If
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        clean_cliente()
    End Sub

    Private Sub clean_cliente()
        TextBox3.ReadOnly = False
        TextBox4.ReadOnly = False
        TextBox5.ReadOnly = False
        TextBox6.ReadOnly = False
        TextBox3.Text = ""
        TextBox4.Text = ""
        TextBox5.Text = ""
        TextBox6.Text = ""
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click 'confirmar retorno do veiculo
        currentAlug = ListBox2.SelectedIndex
        If currentAlug < 0 Then
            MsgBox("Selecione um aluguer")
            Exit Sub
        End If
        Dim a As New Aluguer
        a = CType(ListBox2.Items.Item(currentAlug), Aluguer)
        Dim l As New Log
        Try
            l.Danos = TextBox9.Text
            l.Taxa = TextBox17.Text
            l.Km_feitos = TextBox10.Text
            l.Drop_off = TextBox11.Text
            l.Funcionario = TextBox12.Text
        Catch ex As Exception
            MessageBox.Show(ex.Message)
            Return
        End Try

        CMD.CommandText = "exec p_submit_log @danos, @num_aluguer, @taxa, @km_feitos, @drop_off, @funcionario"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@danos", l.Danos)
        CMD.Parameters.AddWithValue("@num_aluguer", a.Num_aluguer)
        CMD.Parameters.AddWithValue("@taxa", l.Taxa)
        CMD.Parameters.AddWithValue("@km_feitos", l.Km_feitos)
        CMD.Parameters.AddWithValue("@drop_off", l.Drop_off)
        CMD.Parameters.AddWithValue("@funcionario", l.Funcionario)
        CN.Open()
        Try
            CMD.ExecuteNonQuery()
        Catch ex As Exception
            MessageBox.Show("Log nao submetido. " & vbCrLf & "ERROR MESSAGE: " & vbCrLf & ex.Message)
            Return
        Finally
            CN.Close()
        End Try
        CN.Close()
        clean_apos_aluguer()
        clean_cliente()
        ListBox2.Items.Remove(a)
        TextBox7.Text = ""
        TextBox8.Text = ""
        TextBox17.Text = ""
        TextBox10.Text = ""
        TextBox11.Text = ""
        TextBox12.Text = ""
        TextBox9.Text = ""

        get_price(a)

    End Sub
    Private Sub get_price(a As Aluguer)
        Dim valor As Integer
        CMD.CommandText = "select * from func_price_to_pay(@num_aluguer);"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@num_aluguer", a.Num_aluguer)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        While RDR.Read
            Label27.Text = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("preco_total")), "", RDR.Item("preco_total")))
        End While
        CN.Close()

    End Sub
    'e para ler os alugueres para o listbox2
    Private Sub read_alug()
        Button5.Show()
        Dim a As New Aluguer
        a.Num_aluguer = TextBox8.Text
        a.Veiculo = TextBox7.Text

        CMD.CommandText = "exec p_get_alug"
        CMD.Parameters.Clear()
        ListBox2.Items.Clear()
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        While RDR.Read
            a.Num_aluguer = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_aluguer")), "", RDR.Item("num_aluguer")))
            a.Veiculo = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("vin")), "", RDR.Item("vin")))
            ListBox2.Items.Add(a)
        End While
        CN.Close()
    End Sub

    Private Sub Button7_Click(sender As Object, e As EventArgs)
        read_alug()
    End Sub
    Private Sub ListBox2_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ListBox2.SelectedIndexChanged
        If ListBox2.SelectedIndex > -1 Then
            currentAlug = ListBox2.SelectedIndex
            Dim a As New Aluguer
            a = CType(ListBox2.Items(currentAlug), Aluguer)
            TextBox8.Text = a.Num_aluguer
            TextBox7.Text = a.Veiculo
        End If
    End Sub
End Class
