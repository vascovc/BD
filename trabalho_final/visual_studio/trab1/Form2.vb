Imports System.IO
Imports System.Runtime.Serialization.Formatters.Binary
Imports System.Data.SqlClient
Public Class Form2
    Dim CN As SqlConnection
    Dim CMD As SqlCommand

    Dim currentVeiculo As Integer

    Dim var_marca As String
    Dim var_modelo As String
    Dim var_ano As String
    Dim var_combs As String
    Dim var_transm As String
    Private Sub Form2_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.WindowState = FormWindowState.Maximized
        CN = New SqlConnection("data source=VASCO-FIXO\TEW_SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = New SqlConnection("data source=VASCO\TEW_SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = New SqlConnection("data source=LAPTOP-GECIRST1\SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = Form1.connect_to_bd()
        CMD = New SqlCommand
        CMD.Connection = CN
        hide_alug_options()
        clean_apos_trade()
    End Sub

    Private Sub SairToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles SairToolStripMenuItem.Click
        End
    End Sub

    Private Sub AluguerToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles AluguerToolStripMenuItem.Click
        Form1.Show()
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
    Private Sub clean_apos_trade()
        Button1.Hide()
        Button2.Hide()
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
        load_c_balcao()
        load_trans()
        load_comb()
    End Sub
    Private Sub load_balcao()
        CMD.CommandText = "exec p_balcao"
        CMD.Parameters.Clear()
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox8.Items.Clear() 'balcao
        ComboBox8.Items.Add("")
        While RDR.Read
            Dim b As New Balcao
            b.Numero = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("numero")), "", RDR.Item("numero")))
            ComboBox8.Items.Add(b.Numero)
        End While
        CN.Close()
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
        End If
    End Sub
    Private Sub ComboBox7_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox7.SelectedIndexChanged
        'ano
        If ComboBox7.SelectedIndex > -1 Then
            var_ano = ComboBox7.SelectedItem
            load_veiculos()
            load_marcas()
            load_modelos()
            load_transmissao()
            load_combustivel()
        End If
    End Sub
    Private Sub ComboBox3_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox3.SelectedIndexChanged
        'combustivel
        If ComboBox3.SelectedIndex > -1 Then
            var_combs = ComboBox3.SelectedItem
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
            load_veiculos()
            load_marcas()
            load_ano()
            load_transmissao()
            load_modelos()
        End If
    End Sub
    Private Sub ComboBox4_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox4.SelectedIndexChanged
        'transmissao
        If ComboBox4.SelectedIndex > -1 Then
            var_transm = ComboBox4.SelectedItem
            Select Case var_transm
                Case "Manual"
                    var_transm = "1"
                Case "Automatico"
                    var_transm = "2"
            End Select
            load_veiculos()
            load_marcas()
            load_ano()
            load_combustivel()
            load_modelos()
        End If
    End Sub
    Private Sub ComboBox8_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ComboBox8.SelectedIndexChanged
        'transmissao
        If ComboBox8.SelectedIndex > -1 Then
            load_veiculos()
        End If
    End Sub
    Private Sub load_marcas()
        CMD.CommandText = "exec p_marcas_Venda @var_modelo, @var_ano, @var_combs, @var_transm"
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
            Dim V As New Veiculo_venda
            V.Marca = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("marca")), "", RDR.Item("marca")))
            ComboBox1.Items.Add(V.Marca)
        End While
        CN.Close()
    End Sub
    Private Sub load_modelos()
        CMD.CommandText = "exec p_modelos_venda @marca, @ano, @combs, @transmissao"
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
            Dim V As New Veiculo_venda
            V.Modelo = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("modelo")), "", RDR.Item("modelo")))
            ComboBox2.Items.Add(V.Modelo)
        End While
        CN.Close()
    End Sub
    Private Sub load_ano()
        CMD.CommandText = "exec p_anos_venda @marca, @modelo, @combs, @transmissao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@marca", var_marca)
        CMD.Parameters.AddWithValue("@modelo", var_modelo)
        CMD.Parameters.AddWithValue("@combs", var_combs)
        CMD.Parameters.AddWithValue("@transmissao", var_transm)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox7.Items.Clear() 'ano
        ComboBox7.Items.Add("")
        While RDR.Read
            Dim V As New Veiculo_venda
            V.Ano = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("ano")), "", RDR.Item("ano")))
            ComboBox7.Items.Add(V.Ano)
        End While
        CN.Close()
    End Sub
    Private Sub load_combustivel()
        CMD.CommandText = "exec p_combustivel_venda @modelo, @marca, @ano, @transmissao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@modelo", var_modelo)
        CMD.Parameters.AddWithValue("@marca", var_marca)
        CMD.Parameters.AddWithValue("@ano", var_ano)
        CMD.Parameters.AddWithValue("@transmissao", var_transm)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox3.Items.Clear() 'combustivel
        ComboBox3.Items.Add("")
        While RDR.Read
            Dim V As New Veiculo_venda
            V.Combustivel = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("combustivel")), "", RDR.Item("combustivel")))

            ComboBox3.Items.Add(V.Combustivel)

        End While
        CN.Close()
    End Sub
    Private Sub load_transmissao()
        CMD.CommandText = "exec p_transmissao_venda @modelo, @marca, @ano, @combustivel"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@modelo", var_modelo)
        CMD.Parameters.AddWithValue("@marca", var_marca)
        CMD.Parameters.AddWithValue("@ano", var_ano)
        CMD.Parameters.AddWithValue("@combustivel", var_combs)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ComboBox4.Items.Clear() 'modelos
        ComboBox4.Items.Add("")
        While RDR.Read
            Dim V As New Veiculo_venda
            V.Transmissao = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("transmissao")), "", RDR.Item("transmissao")))
            ComboBox4.Items.Add(V.Transmissao)
        End While
        CN.Close()
    End Sub
    Private Sub load_veiculos()
        Dim b As New Balcao
        b.Numero = ComboBox8.Text
        CMD.CommandText = "exec p_veiculos_venda @marca, @modelo, @ano, @combs, @transmissao, @balcao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@marca", var_marca)
        CMD.Parameters.AddWithValue("@modelo", var_modelo)
        CMD.Parameters.AddWithValue("@ano", var_ano)
        CMD.Parameters.AddWithValue("@combs", var_combs)
        CMD.Parameters.AddWithValue("@transmissao", var_transm)
        CMD.Parameters.AddWithValue("@balcao", b.Numero)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ListBox1.Items.Clear() 'pagina dos veiculos
        While RDR.Read
            Dim V As New Veiculo_venda
            V.Vin = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("vin")), "", RDR.Item("vin")))
            V.Marca = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("marca")), "", RDR.Item("marca")))
            V.Modelo = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("modelo")), "", RDR.Item("modelo")))
            V.Matricula = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("matricula")), "", RDR.Item("matricula")))
            V.Km = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("km")), "", RDR.Item("km")))
            V.Ano = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("ano")), "", RDR.Item("ano")))
            V.Hp = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("hp")), "", RDR.Item("hp")))
            V.Localizacao = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("localizacao")), "", RDR.Item("localizacao")))
            V.Valor_comercial = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("valor_comerc")), "", RDR.Item("valor_comerc")))
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
        Dim veiculo As New Veiculo_venda
        Dim al As String
        veiculo = CType(ListBox1.Items.Item(currentVeiculo), Veiculo)
        TextBox2.Text = veiculo.Hp
        TextBox3.Text = veiculo.Km
        TextBox4.Text = veiculo.Valor_comercial
        TextBox13.Text = veiculo.Valor_comercial * 1.15

        CMD.CommandText = "exec p_get_log @vin"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@vin", veiculo.Vin)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        ListBox2.Items.Clear() 'log
        While RDR.Read
            Dim l As New Log
            l.Danos = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("danos")), "", RDR.Item("danos")))
            al = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_aluguer")), "", RDR.Item("num_aluguer")))
            ListBox2.Items.Add(al & " -> " & l.Danos)
        End While
        CN.Close()
    End Sub

    'nao sei se ficou a funcionar mas e para aparecer so se for para alugar
    Private Sub CheckBox1_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked Then
            show_alug_options()
        Else
            hide_alug_options()
        End If
    End Sub
    Private Sub show_alug_options()
        Label25.Show()
        Label26.Show()
        TextBox1.Show()
        TextBox14.Show()
    End Sub
    Private Sub hide_alug_options()
        Label25.Hide()
        Label26.Hide()
        TextBox1.Hide()
        TextBox14.Hide()
    End Sub
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        currentVeiculo = ListBox1.SelectedIndex

        If currentVeiculo < 0 Then
            MsgBox("Selecione um veiculo")
            Exit Sub
        End If
        Dim veiculo As New Veiculo_venda
        veiculo = CType(ListBox1.Items.Item(currentVeiculo), Veiculo)
        Submit_venda(veiculo)
    End Sub

    Private Sub Submit_venda(ByVal V As Veiculo_venda)
        Dim c As New Cliente
        Dim b As New Balcao
        Dim f As New Funcionario
        Dim venda As New venda
        Try
            c.Num_cliente = TextBox17.Text
            b.Numero = ComboBox8.Text
            If ComboBox8.Text = "" Then
                b.Numero = V.Localizacao
            End If
            f.Num_empregado = TextBox22.Text
            venda.Metodo_pagamento = TextBox23.Text
        Catch ex As Exception
            MessageBox.Show(ex.Message)
            Return
        End Try

        CMD.CommandText = "exec p_submit_venda @vin, @metodo_pagamento, @cliente, @balcao, @funcionario, @valor_Venda"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@metodo_pagamento", venda.Metodo_pagamento)
        CMD.Parameters.AddWithValue("@cliente", c.Num_cliente)
        CMD.Parameters.AddWithValue("@balcao", b.Numero)
        CMD.Parameters.AddWithValue("@vin", V.Vin)
        CMD.Parameters.AddWithValue("@funcionario", f.Num_empregado)
        CMD.Parameters.AddWithValue("@valor_venda", TextBox13.Text)
        CN.Open()
        Try
            CMD.ExecuteNonQuery()
        Catch ex As Exception
            MessageBox.Show("Venda não efetuada. " & vbCrLf & "ERROR MESSAGE: " & vbCrLf & ex.Message)
            Return
        Finally
            CN.Close()
        End Try
        CN.Close()
        clean_apos_trade()
        clean_cliente()
        TextBox13.Text = ""
        TextBox14.Text = ""
    End Sub

    Private Sub Submit_compra()
        Dim c As New Cliente
        Dim b As New Balcao
        Dim f As New Funcionario
        Dim compra As New Compra
        Dim v As New Veiculo
        Dim va As New Veiculo_aluguer
        Dim vc As New Veiculo_venda
        Dim var_c As String
        Dim var_v As String
        Try
            v.Vin = TextBox5.Text
            v.Marca = TextBox6.Text
            v.Modelo = TextBox7.Text
            v.Matricula = TextBox24.Text
            v.Seguro = TextBox8.Text
            v.Km = TextBox9.Text
            v.Ano = TextBox12.Text
            v.Combustivel = ComboBox9.Text
            Select Case v.Combustivel
                Case "Gasolina"
                    var_c = "1"
                Case "Gasoleo"
                    var_c = "2"
                Case "Eletrico"
                    var_c = "3"
                Case "GPL"
                    var_c = "4"
                Case "Hybrid"
                    var_c = "5"
            End Select

            v.Hp = TextBox10.Text
            v.Transmissao = ComboBox5.Text
            Select Case v.Transmissao
                Case "Manual"
                    var_v = "1"
                Case "Automatico"
                    var_v = "2"
            End Select
            vc.Valor_comercial = TextBox15.Text
            va.Limit_km_dia = TextBox14.Text
            va.Preco_dia = TextBox1.Text
            f.Num_empregado = TextBox22.Text
            b.Numero = ComboBox6.Text
            c.Num_cliente = TextBox17.Text
            v.Estado = "1"
            If va.Limit_km_dia <> "" Then
                v.Estado = "0"
            End If
        Catch ex As Exception
            MessageBox.Show(ex.Message)
            Return
        End Try

        CMD.CommandText = "exec p_submit_compra @vin, @marca, @modelo, @matricula, @seguro, @km, @ano, @combustivel, @hp, @transmissao, @estado, @limit_km_dia, @preco_dia, @valor_comerc, @client_vend, @balcao, @funcionario, @valor_pago"
        CMD.Parameters.Clear()
        'MessageBox.Show(v.Vin)
        CMD.Parameters.AddWithValue("@vin", v.Vin)
        'MessageBox.Show(v.Marca)
        CMD.Parameters.AddWithValue("@marca", v.Marca)
        'MessageBox.Show(v.Modelo)
        CMD.Parameters.AddWithValue("@modelo", v.Modelo)
        'MessageBox.Show(v.Matricula)
        CMD.Parameters.AddWithValue("@matricula", v.Matricula)
        'MessageBox.Show(v.Seguro)
        CMD.Parameters.AddWithValue("@seguro", v.Seguro)
        'MessageBox.Show(v.Km)
        CMD.Parameters.AddWithValue("@km", v.Km)
        'MessageBox.Show(v.Ano)
        CMD.Parameters.AddWithValue("@ano", v.Ano)
        'MessageBox.Show(var_c)
        CMD.Parameters.AddWithValue("@combustivel", var_c)
        'MessageBox.Show(v.Hp)
        CMD.Parameters.AddWithValue("@hp", v.Hp)
        'MessageBox.Show(var_v)
        CMD.Parameters.AddWithValue("@transmissao", var_v)
        'MessageBox.Show(v.Estado)
        CMD.Parameters.AddWithValue("@estado", v.Estado)
        'MessageBox.Show(va.Limit_km_dia)
        CMD.Parameters.AddWithValue("@limit_km_dia", va.Limit_km_dia)
        'MessageBox.Show(va.Preco_dia)
        CMD.Parameters.AddWithValue("@preco_dia", va.Preco_dia)
        'MessageBox.Show(vc.Valor_comercial)
        CMD.Parameters.AddWithValue("@valor_comerc", vc.Valor_comercial)
        'MessageBox.Show(c.Num_cliente)
        CMD.Parameters.AddWithValue("@client_vend", c.Num_cliente)
        'MessageBox.Show(b.Numero)
        CMD.Parameters.AddWithValue("@balcao", b.Numero)
        'MessageBox.Show(f.Num_empregado)
        CMD.Parameters.AddWithValue("@funcionario", f.Num_empregado)
        'MessageBox.Show(TextBox16.Text.ToString)
        CMD.Parameters.AddWithValue("@valor_pago", TextBox16.Text.ToString)
        CN.Open()
        Try
            CMD.ExecuteNonQuery()
        Catch ex As Exception
            MessageBox.Show("Compra não efetuada. " & vbCrLf & "ERROR MESSAGE: " & vbCrLf & ex.Message)
            Return
        Finally
            CN.Close()
        End Try
        CN.Close()
        clean_apos_trade()
        clean_cliente()
        TextBox13.Text = ""
        TextBox14.Text = ""
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        clean_cliente()
    End Sub

    Private Sub clean_cliente()
        TextBox20.ReadOnly = False
        TextBox19.ReadOnly = False
        TextBox18.ReadOnly = False
        TextBox17.ReadOnly = False
        TextBox20.Text = ""
        TextBox19.Text = ""
        TextBox18.Text = ""
        TextBox17.Text = ""
        Button1.Hide()
        Button2.Hide()
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        TextBox20.ReadOnly = True
        TextBox19.ReadOnly = True
        TextBox18.ReadOnly = True
        TextBox17.ReadOnly = True
        Dim c As New Cliente
        If TextBox19.Text = "" And TextBox18.Text = "" And TextBox17.Text = "" Then
            MessageBox.Show("Insira algum dado do cliente")
            clean_cliente()
            Return
        End If
        If TextBox19.Text <> "" Then
            c.Carta = TextBox19.Text
        End If
        If TextBox18.Text <> "" Then
            c.NIF = TextBox18.Text
        End If
        If TextBox17.Text <> "" Then
            c.Num_cliente = TextBox17.Text
        End If
        CMD.CommandText = "exec p_get_num_cliente @nif, @carta, @num_cliente"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@nif", TextBox18.Text.ToString)
        CMD.Parameters.AddWithValue("@carta", TextBox19.Text.ToString)
        CMD.Parameters.AddWithValue("@num_cliente", TextBox17.Text.ToString)
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
        TextBox17.Text = c.Num_cliente
        TextBox18.Text = c.NIF
        TextBox19.Text = c.Carta
        TextBox20.Text = c.Nome

        If c.Nome <> "" Then
            Button1.Show()
            Button2.Show()
        End If
    End Sub
    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Form3.Show()
        Form3.TextBox1.Text = TextBox3.Text
        Form3.TextBox3.Text = TextBox4.Text
        Form3.TextBox2.Text = TextBox5.Text
        Form3.TextBox11.Text = TextBox6.Text
        Me.Hide()
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Submit_compra()
    End Sub

    Private Sub load_c_balcao()
        ComboBox6.Items.Clear()
        ComboBox6.Items.Add("1")
        ComboBox6.Items.Add("2")
        ComboBox6.Items.Add("3")
    End Sub

    Private Sub load_trans()
        ComboBox5.Items.Clear()
        ComboBox5.Items.Add("Manual")
        ComboBox5.Items.Add("Automatico")
    End Sub

    Private Sub load_comb()
        ComboBox9.Items.Clear()
        ComboBox9.Items.Add("Gasolina")
        ComboBox9.Items.Add("Gasoleo")
        ComboBox9.Items.Add("Eletrico")
        ComboBox9.Items.Add("GPL")
        ComboBox9.Items.Add("Hybrid")
    End Sub
End Class