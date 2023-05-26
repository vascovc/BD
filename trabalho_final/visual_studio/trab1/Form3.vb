Imports System.IO
Imports System.Runtime.Serialization.Formatters.Binary
Imports System.Data.SqlClient

Public Class Form3
    Dim CN As SqlConnection
    Dim CMD As SqlCommand

    Dim client_adding As Boolean
    Private Sub Form3_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.WindowState = FormWindowState.Maximized
        CN = New SqlConnection("data source=VASCO-FIXO\TEW_SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = New SqlConnection("data source=VASCO\TEW_SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = New SqlConnection("data source=LAPTOP-GECIRST1\SQLEXPRESS;integrated security=true;initial catalog=Rent_buy_car")
        'CN = Form1.connect_to_bd()
        CMD = New SqlCommand
        CMD.Connection = CN
        Label18.Hide()
        TextBox13.Hide()
        Button2.Hide()
        Button5.Hide()
        Button6.Hide()
        Button7.Hide()
    End Sub
    Private Sub AluguerToolStripMenuItem1_Click(sender As Object, e As EventArgs) Handles AluguerToolStripMenuItem1.Click
        Form1.Show()
        Me.Hide()
    End Sub

    Private Sub CompraToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CompraToolStripMenuItem.Click
        Form2.Show()
        Me.Hide()
    End Sub

    Private Sub SairToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles SairToolStripMenuItem.Click
        End
    End Sub

    Private Sub EstatísticasToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles EstatísticasToolStripMenuItem.Click
        Form4.Show()
        Me.Hide()
    End Sub
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Try
            Save_cliente()
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try

    End Sub

    Private Function Save_cliente() As Boolean
        Dim cliente As New Cliente
        Try
            cliente.Nome = TextBox1.Text
            cliente.NIF = TextBox2.Text
            cliente.Carta = TextBox3.Text
            cliente.Email = TextBox4.Text
            cliente.Telemovel = TextBox7.Text
            cliente.Data_nascimento = DateTimePicker1.Value.Year & "-" & DateTimePicker1.Value.Month & "-" & DateTimePicker1.Value.Day
            cliente.Morada = TextBox5.Text & ";" & TextBox6.Text & ";" & TextBox8.Text
            Submit_cliente(cliente)
        Catch ex As Exception
            MsgBox(ex.Message)
            Return False
        End Try
        Return True
    End Function

    Private Function Submit_cliente(ByVal cliente As Cliente)

        CMD.CommandText = "exec p_new_cliente @nif, @nome, @morada, @data_nascimento, @phone,
							                    @email, @num_carta"

        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@nif", cliente.NIF)
        CMD.Parameters.AddWithValue("@nome", cliente.Nome)
        CMD.Parameters.AddWithValue("@morada", cliente.Morada)
        'MessageBox.Show(cliente.Data_nascimento)
        CMD.Parameters.AddWithValue("@data_nascimento", cliente.Data_nascimento)
        CMD.Parameters.AddWithValue("@phone", cliente.Telemovel)
        CMD.Parameters.AddWithValue("@email", cliente.Email)
        CMD.Parameters.AddWithValue("@num_carta", cliente.Carta)
        CN.Open()
        Try
            CMD.ExecuteNonQuery()
        Catch ex As Exception
            Throw New Exception("Falhou inserir cliente. " & vbCrLf & "ERROR MESSAGE: " & vbCrLf & ex.Message)
        Finally
            CN.Close()
        End Try
        CN.Close()

        CMD.CommandText = "exec p_get_num_cliente @nif, @carta, @num_cliente"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@nif", cliente.NIF)
        CMD.Parameters.AddWithValue("@carta", "")
        CMD.Parameters.AddWithValue("@num_cliente", "")
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        While RDR.Read
            cliente.Num_cliente = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_cliente")), "", RDR.Item("num_cliente")))
        End While
        CN.Close()
        TextBox11.Text = cliente.Num_cliente
        MessageBox.Show("Cliente inserido com sucesso:" & vbCrLf & "    Cliente número: " & cliente.Num_cliente)
        Form1.Show()
        Me.Hide()
        Form1.TextBox6.Text = cliente.Num_cliente
        clean_page()
    End Function

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        Try
            Save_func()
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try
    End Sub

    Private Function Save_func() As Boolean
        Dim func As New Funcionario
        Try
            func.Nome = TextBox1.Text
            func.NIF = TextBox2.Text
            func.Carta = TextBox3.Text
            func.Email = TextBox9.Text & "@r_car.com"
            func.Balcao = TextBox10.Text
            func.Telemovel = TextBox7.Text
            func.Data_nascimento = DateTimePicker1.Value.Year & "-" & DateTimePicker1.Value.Month & "-" & DateTimePicker1.Value.Day
            func.Morada = TextBox5.Text & ";" & TextBox6.Text & ";" & TextBox8.Text
            Submit_func(func)
        Catch ex As Exception
            MsgBox(ex.Message)
            Return False
        End Try
        Return True
    End Function

    Private Function Submit_func(ByVal func As Funcionario)
        CMD.CommandText = "exec p_new_func @nif, @nome, @morada, @data_nascimento, @phone,
							@email, @num_carta, @balcao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@nif", func.NIF)
        CMD.Parameters.AddWithValue("@nome", func.Nome)
        CMD.Parameters.AddWithValue("@morada", func.Morada)
        CMD.Parameters.AddWithValue("@data_nascimento", func.Data_nascimento)
        CMD.Parameters.AddWithValue("@phone", func.Telemovel)
        CMD.Parameters.AddWithValue("@email", func.Email)
        CMD.Parameters.AddWithValue("@num_carta", func.Carta)
        CMD.Parameters.AddWithValue("@balcao", func.Balcao)
        CN.Open()
        Try
            CMD.ExecuteNonQuery()
        Catch ex As Exception
            Throw New Exception("Falhou inserir funcionario. " & vbCrLf & "ERROR MESSAGE: " & vbCrLf & ex.Message)
        Finally
            CN.Close()
        End Try
        CN.Close()
        CMD.CommandText = "exec p_get_num_emp @nif"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@nif", func.NIF)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        While RDR.Read
            func.Num_empregado = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_empregado")), "", RDR.Item("num_empregado")))
        End While
        CN.Close()
        MessageBox.Show("Funcionário inserido com sucesso:" & vbCrLf & "    Funcionário número: " & func.Num_empregado)
        Form1.Show()
        Me.Hide()
        clean_page()
    End Function

    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click
        Label18.Show()
        TextBox13.Show()
        Button5.Show()
        TextBox13.ReadOnly = False
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        Dim func As New Funcionario
        Try
            func.Num_empregado = TextBox13.Text
        Catch ex As Exception
            MsgBox(ex.Message)
            Return
        End Try
        TextBox13.ReadOnly = True
        CMD.CommandText = "exec p_get_func @num_func"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@num_func", func.Num_empregado)
        CN.Open()
        Dim RDR As SqlDataReader
        RDR = CMD.ExecuteReader
        While RDR.Read
            func.Morada = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("morada")), "", RDR.Item("morada")))
            func.Carta = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("num_carta")), "", RDR.Item("num_carta")))
            func.Telemovel = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("phone")), "", RDR.Item("phone")))
            func.Balcao = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("balcao")), "", RDR.Item("balcao")))
            func.Nome = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("nome")), "", RDR.Item("nome")))
            func.Data_nascimento = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("data_nascimento")), "", RDR.Item("data_nascimento")))
            func.Email = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("email_empresa")), "", RDR.Item("email_empresa")))
            func.NIF = Convert.ToString(IIf(RDR.IsDBNull(RDR.GetOrdinal("nif")), "", RDR.Item("nif")))
        End While

        CN.Close()
        TextBox2.ReadOnly = True
        TextBox9.ReadOnly = True
        TextBox3.ReadOnly = True
        If func.Carta = "" Then
            TextBox3.ReadOnly = False
        End If
        Label12.Hide()
        Label5.Hide()
        Label16.Hide()
        TextBox4.Hide()
        TextBox11.Hide()
        Button1.Hide()
        Label17.Hide()
        TextBox12.Hide()

        TextBox1.Text = func.Nome
        TextBox2.Text = func.NIF
        TextBox3.Text = func.Carta
        TextBox7.Text = func.Telemovel
        TextBox9.Text = func.Email
        TextBox10.Text = func.Balcao
        DateTimePicker1.Value = func.Data_nascimento
        Dim str() As String = Split(func.Morada, ";")
        TextBox5.Text = str(0)
        TextBox6.Text = str(1)
        TextBox8.Text = str(2)

        Button2.Show()
        Button6.Show()
        Button7.Show()
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click 'demitir
        Dim F As New Funcionario
        F.Num_empregado = TextBox13.Text

        CMD.CommandText = "exec p_demitir_func @num_empregado"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@num_empregado", F.Num_empregado)
        CN.Open()
        Try
            CMD.ExecuteNonQuery()
        Catch ex As Exception
            Throw New Exception("Falhou demitir funcionario. " & vbCrLf & "ERROR MESSAGE: " & vbCrLf & ex.Message)
        Finally
            CN.Close()
        End Try
        CN.Close()
        MessageBox.Show("Funcionário despedido")
        clean_page()
    End Sub

    Private Sub Button7_Click(sender As Object, e As EventArgs) Handles Button7.Click 'cancelar operacao
        Form1.Show()
        Me.Hide()
        clean_page()
    End Sub
    Private Sub clean_page()
        Label18.Hide()
        TextBox13.Text = ""
        TextBox13.Hide()
        Button2.Hide()
        Button5.Hide()
        Button6.Hide()
        Button7.Hide()
        TextBox2.ReadOnly = False
        TextBox9.ReadOnly = False
        TextBox3.ReadOnly = False

        Label12.Show()
        Label5.Show()
        Label16.Show()
        TextBox4.Show()
        TextBox11.Show()
        Button1.Show()
        Label17.Show()
        TextBox12.Show()

        TextBox1.Text = ""
        TextBox2.Text = ""
        TextBox3.Text = ""
        TextBox7.Text = ""
        TextBox9.Text = ""
        TextBox10.Text = ""
        TextBox5.Text = ""
        TextBox6.Text = ""
        TextBox8.Text = ""
        TextBox11.Text = ""
        TextBox4.Text = ""
        Button2.Hide()
        Button6.Hide()
        Button7.Hide()
    End Sub
    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click ' atualizar funcionario
        Dim func As New Funcionario
        Try
            func.Nome = TextBox1.Text
            func.NIF = TextBox2.Text
            func.Carta = TextBox3.Text
            func.Balcao = TextBox10.Text
            func.Telemovel = TextBox7.Text
            func.Morada = TextBox5.Text & ";" & TextBox6.Text & ";" & TextBox8.Text
        Catch ex As Exception
            MessageBox.Show(ex.Message)
            Return
        End Try

        CMD.CommandText = "exec p_update_func @nif, @nome, @morada, @phone,
							@num_carta, @balcao"
        CMD.Parameters.Clear()
        CMD.Parameters.AddWithValue("@nif", Func.NIF)
        CMD.Parameters.AddWithValue("@nome", Func.Nome)
        CMD.Parameters.AddWithValue("@morada", func.Morada)
        CMD.Parameters.AddWithValue("@phone", func.Telemovel)
        CMD.Parameters.AddWithValue("@num_carta", Func.Carta)
        CMD.Parameters.AddWithValue("@balcao", Func.Balcao)
        CN.Open()
        Try
            CMD.ExecuteNonQuery()
        Catch ex As Exception
            Throw New Exception("Falhou atualizar funcionario. " & vbCrLf & "ERROR MESSAGE: " & vbCrLf & ex.Message)
        Finally
            CN.Close()
        End Try
        CN.Close()
        Form1.Show()
        clean_page()
        Me.Hide()

    End Sub


End Class