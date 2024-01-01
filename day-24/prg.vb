Imports System
Imports System.IO
Imports System.Numerics
Imports System.Text

Class Point2
	Public x As Rational
	Public y As Rational
	
	Sub New(x As Rational, y As Rational)
		Me.x = x
		Me.y = y
	End Sub
	
	Overrides Function ToString() As String
		Return $"[{x}, {y}]"
	End Function
End Class

Class Point3
	Inherits Point2
	Public z As Rational
	
	Sub New(x As Rational, y As Rational, z As Rational)
		MyBase.New(x, y)
		Me.z = z
	End Sub
	
	Shared Function IntersectionHomo(l1 As Point3, l2 As Point3) As Point3
		Dim x As Rational = l1.y * l2.z - l2.y * l1.z
		Dim y As Rational = l2.x * l1.z - l1.x * l2.z
		Dim z As Rational = l1.x * l2.y - l2.x * l1.y
		Dim s As Rational = z.Sign()
		Return New Point3(x * s, y * s, z * s)
	End Function
	
	Function Exists2() As Boolean
		Return z <> Rational.Zero
	End Function
	
	Function IsWithinHomo(bl As Point2, tr As Point2) As Boolean
		Dim xWithin As Boolean = x >= bl.x * z And x <= tr.x * z
		Dim yWithin As Boolean = y >= bl.y * z And y <= tr.y * z
		Return xWithin And yWithin
	End Function
	
	Function Homo2() As Point2
		Return New Point2(x / z, y / z)
	End Function
	
	Overrides Function ToString() As String
		Return $"[{x}, {y}, {z}]"
	End Function
End Class

Class Hail
	Public p As Point3
	Public v As Point3
	
	Sub New(p As Point3, v As Point3)
		Me.p = p
		Me.v = v
	End Sub
	
	Function ImplicitLine2() As Point3
		Dim c As Rational = v.x * p.y - v.y * p.x
		Dim l As Point3 = New Point3(v.y, -v.x, c)
		' Console.WriteLine($"implicit {Me}: {l}")
		Return l
	End Function
	
	Shared Function Intersect(h1 As Hail, h2 As Hail) As Point3
		Return Point3.IntersectionHomo(
			h1.ImplicitLine2(),
			h2.ImplicitLine2()
		)
	End Function
	
	Function IsInFuture(h As Point3) As Boolean
		Dim nx As Rational = h.x - p.x * h.z
		Dim dx As Rational = v.x * h.z
		Return nx.Sign() = dx.Sign()
	End Function
	
	Overrides Function ToString() As String
		Return $"{p} @ {v}"
	End Function
End Class

Class Rational
	Public n As BigInteger
	Public d As BigInteger
	
	Public Shared One As Rational = New Rational(BigInteger.One)
	Public Shared Zero As Rational = New Rational(BigInteger.Zero)
	
	Sub New(n As BigInteger)
		Me.n = n
		Me.d = BigInteger.One
	End Sub
	
	Sub New(n As BigInteger, d As BigInteger)
		Me.n = n
		Me.d = d
	End Sub
	
	Public Function Sign() As Rational
		If Me = Zero Then
			Return One
		ElseIf Me < Zero
			Return -One
		Else
			Return One
		End If
	End Function
	
	Public Function Abs() As Rational
		If Me < Zero Then
			Return -Me
		Else
			Return Me
		End If
	End Function
	
	Overrides Function ToString() As String
		If d = 1 Then
			Return $"{n}"
		Else
			'Return $"({n}/{d} = {n / d} + {n MOD d}/{d})"
			'Return $"~{n / d}"
			'Return $"{n / d} + {n MOD d}/{d}"
			Return $"{n}/{d}"
		End If
	End Function
	
	Public Shared Operator +(a As Rational) As Rational
		Return a
	End Operator
	
	Public Shared Operator -(a As Rational) As Rational
		Return New Rational(-a.n, a.d)
	End Operator
	
	Public Shared Operator +(a As Rational, b As Rational) As Rational
		Dim n As BigInteger = a.n * b.d + b.n * a.d
		Dim d As BigInteger = a.d * b.d
		Dim gcd As BigInteger = BigInteger.GreatestCommonDivisor(n, d)
		Return New Rational(n / gcd, d / gcd)
	End Operator
	
	Public Shared Operator -(a As Rational, b As Rational) As Rational
		Dim n As BigInteger = a.n * b.d - b.n * a.d
		Dim d As BigInteger = a.d * b.d
		Dim gcd As BigInteger = BigInteger.GreatestCommonDivisor(n, d)
		Return New Rational(n / gcd, d / gcd)
	End Operator
	
	Public Shared Operator *(a As Rational, b As Rational) As Rational
		Dim n As BigInteger = a.n * b.n
		Dim d As BigInteger = a.d * b.d
		Dim gcd As BigInteger = BigInteger.GreatestCommonDivisor(n, d)
		Return New Rational(n / gcd, d / gcd)
	End Operator
	
	Public Shared Operator /(a As Rational, b As Rational) As Rational
		If b.n.IsZero Then
			Throw New System.DivideByZeroException()
		End If
		Dim n As BigInteger = a.n * b.d
		Dim d As BigInteger = a.d * b.n
		Dim gcd As BigInteger = BigInteger.GreatestCommonDivisor(n, d)
		Return New Rational(n / BigInteger.CopySign(gcd, d), BigInteger.Abs(d) / gcd)
	End Operator
	
	Public Shared Operator =(a As Rational, b As Rational) As Boolean
		Return a.n = b.n And a.d = b.d
	End Operator
	
	Public Shared Operator <>(a As Rational, b As Rational) As Boolean
		Return a.n <> b.n Or a.d <> b.d
	End Operator
	
	Public Shared Operator <(a As Rational, b As Rational) As Boolean
		Return a.n * b.d < b.n * a.d
	End Operator
	
	Public Shared Operator >(a As Rational, b As Rational) As Boolean
		Return a.n * b.d > b.n * a.d
	End Operator
	
	Public Shared Operator <=(a As Rational, b As Rational) As Boolean
		Return a.n * b.d <= b.n * a.d
	End Operator
	
	Public Shared Operator >=(a As Rational, b As Rational) As Boolean
		Return a.n * b.d >= b.n * a.d
	End Operator
End Class

class Vector
	Private elems() As Rational = {}

	Sub Add(elem As Rational)
		Redim Preserve elems(elems.Length)
		elems(elems.Length - 1) = elem
	End Sub
	
	Function At(index As Integer)
		Return elems(index)
	End Function
	
	Sub SubtractMultiple(other As Vector, val As Rational)
		For i = 0 To elems.Length - 1
			elems(i) -= other.elems(i) * val
		Next
	End Sub
	
	Sub Divide(val As Rational)
		For i = 0 To elems.Length - 1
			elems(i) /= val
		Next
	End Sub
	
	Overrides Function ToString() As String
		Dim s As StringBuilder = New StringBuilder("(")
		For i = 0 To elems.Length - 1
			If i > 0 Then
				s.Append(",")
				s.Append(vbTab)
			End If
			s.Append(elems(i))
		Next
		s.Append(")")
		Return s.ToString()
	End Function
End Class

Class Matrix
	Private eqns() As Vector = {}
	
	Sub AddRow(eqn As Vector)
		Redim Preserve eqns(eqns.Length)
		eqns(eqns.Length - 1) = eqn
	End Sub
	
	Private Sub swapWith(i As Integer, j As Integer)
		If i <> j Then
			' Console.WriteLine($"Swapping {i} {j}")
			Dim tmp As Vector = eqns(i)
			eqns(i) = eqns(j)
			eqns(j) = tmp
		End If
	End Sub
	
	Private Function pickBestRowDown(from As Integer) As Integer
		For i = from To eqns.Length - 1
			If eqns(i).At(from) <> Rational.Zero Then
				Return i
			End If
		Next
		Throw New System.ApplicationException("Could not find non-zero row")
	End Function
	
	Private Sub passDown(from As Integer)
		Dim swap As Integer = pickBestRowDown(from)
		swapWith(from, swap)
		Dim val As Rational = eqns(from).At(from)
		eqns(from).Divide(val)
		For i = from + 1 To eqns.Length - 1
			val = eqns(i).At(from)
			eqns(i).SubtractMultiple(eqns(from), val)
		Next
	End Sub
	
	Private Sub passUp(row As Integer)
		For i = 0 To row - 1
			Dim val As Rational = eqns(i).At(row)
			eqns(i).SubtractMultiple(eqns(row), val)
		Next
	End Sub
	
	Private Sub passesDown(lhs As Integer)
		For i = 0 To lhs - 1
			' Console.WriteLine(Me)
			passDown(i)
		Next
	End Sub
	
	Private Sub passesUp(lhs As Integer)
		For i = lhs - 1 To 0 Step -1
			' Console.WriteLine(Me)
			passUp(i)
		Next
	End Sub
	
	Private Function extract(lhs As Integer, rhs As Integer) As Vector
		Dim res As Vector = New Vector()
		For i = 0 To lhs - 1
			res.Add(eqns(i).At(rhs))
		Next
		Return res
	End Function
	
	Function Solve(lhs As Integer, rhs As Integer) As Vector
		passesDown(lhs)
		passesUp(lhs)
		' Console.WriteLine(Me)
		Return extract(lhs, rhs)
	End Function
	
	Overrides Function ToString() As String
		Dim s As StringBuilder = New StringBuilder("[")
		For i = 0 To eqns.Length - 1
			If i > 0 Then
				s.Append(vbLf)
			End If
			s.Append(eqns(i))
		Next
		s.Append("]")
		Return s.ToString()
	End Function
End Class

Module Program
	Function parseRational(line As String) As Rational
		Return New Rational(BigInteger.Parse(line))
	End Function

	Function parsePoint3(line As String) As Point3
		Dim xyz() As String = line.Split(","c)
		Dim x, y, z As Rational
		x = parseRational(xyz(0).Trim())
		y = parseRational(xyz(1).Trim())
		z = parseRational(xyz(2).Trim())
		Return New Point3(x, y, z)
	End Function

	Function parseHail(line As String) As Hail
		' Console.WriteLine($"parsing: {line}")
		Dim pv() As String = line.Split("@"c)
		Dim p, v As Point3
		p = parsePoint3(pv(0).Trim())
		v = parsePoint3(pv(1).Trim())
		Return New Hail(p, v)
	End Function

	Function loadHails(fileName As String) As Hail()
		Dim hails() As Hail
		Dim lines As String() = File.ReadAllLines(fileName)
		ReDim hails(lines.Length - 1)
		For i = 0 To lines.Length - 1
			hails(i) = parseHail(lines(i))
		Next
		Return hails
	End Function

	Function intersections(hails() As Hail, bl As Point2, tr As Point2) As Integer
		Dim cnt As Integer = 0
		For i = 0 To hails.Length - 1
			Dim h1 As Hail = hails(i)
			For j = i + 1 To hails.Length - 1
				Dim h2 As Hail = hails(j)
				Dim int As Point3 = Hail.Intersect(h1, h2)
				
				' Console.WriteLine($"{h1} AND {h2} AT {int}")
				
				If Not int.Exists2() Then
					' Console.WriteLine($"{i}-{j}: Not intersect")
					' Console.WriteLine()
					Continue For
				End If
				
				' Console.WriteLine($"AT {int.Homo2()}")
				
				Dim valid As Boolean = True
				If Not int.IsWithinHomo(bl, tr) Then
					' Console.WriteLine($"{i}-{j}: Outside")
					valid = False
				End If
				
				If Not h1.IsInFuture(int) Then
					' Console.WriteLine($"{i}-{j}: In past 1")
					valid = False
				End If
				
				If Not h2.IsInFuture(int) Then
					' Console.WriteLine($"{i}-{j}: In past 2")
					valid = False
				End If
				
				If valid Then
					' Console.WriteLine($"{i}-{j}: Inside")
					cnt += 1
				End If
				
				' Console.WriteLine()
			Next
		Next
		Return cnt
	End Function
	
	Function ToVectorXY(h As Hail) As Vector
		Dim vec As vector = New Vector()
		vec.Add(h.v.y) ' x
		vec.Add(-h.p.y) ' dx
		
		vec.Add(-h.v.x) ' y
		vec.Add(h.p.x) ' dy
		
		vec.Add(Rational.One) ' y dx - x dy
		
		vec.Add(h.p.x * h.v.y - h.p.y * h.v.x) ' const
		Return vec
	End Function
	
	Function ToVectorXZ(h As Hail) As Vector
		Dim vec As vector = New Vector()
		vec.Add(h.v.z) ' x
		vec.Add(-h.p.z) ' dx
		
		vec.Add(-h.v.x) ' z
		vec.Add(h.p.x) ' dz
		
		vec.Add(Rational.One) ' z dx - x dz
		
		vec.Add(h.p.x * h.v.z - h.p.z * h.v.x) ' const
		Return vec
	End Function
	
	Function ToVectorYZ(h As Hail) As Vector
		Dim vec As vector = New Vector()
		vec.Add(h.v.z) ' y
		vec.Add(-h.p.z) ' dy
		
		vec.Add(-h.v.y) ' z
		vec.Add(h.p.y) ' dz
		
		vec.Add(Rational.One) ' z dy - y dz
		
		vec.Add(h.p.y * h.v.z - h.p.z * h.v.y) ' const
		Return vec
	End Function
	
	Function ToMatrix(hails() As Hail, toVector As Func(Of Hail, Vector)) As Matrix
		Dim m = New Matrix()
		For i = 0 To hails.Length - 1
			Dim hail as Hail = hails(i)
			m.AddRow(toVector(hail))
		Next
		Return m
	End Function

	Sub Main(args As String())
		Dim fileName As String = args(0)
		' Console.WriteLine(fileName)
		
		Dim min As Rational = parseRational(args(1))
		' Console.WriteLine(min)
		
		Dim max As Rational = parseRational(args(2))
		' Console.WriteLine(max)
		
		Dim hails() As Hail = loadHails(fileName)
		' Console.WriteLine(hails.Length)
		
		Dim bl As Point2 = New Point2(min, min)
		Dim tr As Point2 = New Point2(max, max)
		
		Dim ints As Integer = intersections(hails, bl, tr)
		Console.WriteLine(ints)
		
		Dim xyz As Rational = Rational.Zero
		Dim matrix As Matrix = ToMatrix(hails, AddressOf ToVectorXY)
		Dim res As Vector = matrix.Solve(5, 5)
		' Console.WriteLine(res)
		xyz += res.At(0)
		xyz += res.At(2)
		
		matrix = ToMatrix(hails, AddressOf ToVectorXZ)
		res = matrix.Solve(5, 5)
		' Console.WriteLine(res)
		xyz += res.At(2)
		
		Console.WriteLine(xyz)
	End Sub
End Module
