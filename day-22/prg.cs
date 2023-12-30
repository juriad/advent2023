using System;
using System.IO;
using System.Text;

record Point2(int X, int Y)
{
  public override string ToString()
  {
    return $"[{X}, {Y}]";
  }
}

record Point3(Point2 XY, int Z)
{
  public Point3 DZ(int dz)
  {
    return new Point3(XY, Z + dz);
  }
  
  public override string ToString()
  {
    return $"[{XY.X}, {XY.Y}, {Z}]";
  }
}

record Brick(int Id, Point3 From, Point3 To)
{
  public IList<Point2> Projection()
  {
    IList<Point2> proj = new List<Point2>();
    for (int x = From.XY.X; x <= To.XY.X; x++)
    {
      for (int y = From.XY.Y; y <= To.XY.Y; y++)
      {
        proj.Add(new Point2(x, y));
      }
    }
    return proj;
  }
  
  public Brick DownTo(int Z)
  {
    int dz = Z - From.Z;
    return new Brick(Id, From.DZ(dz), To.DZ(dz));
  }
  
  public override string ToString()
  {
    return $"{Id}: {From} ~ {To}";
  }
}

sealed record SetBrick(
  Brick Brick, 
  ISet<SetBrick> Under, 
  ISet<SetBrick> Above)
{
  public int Top
  {
    get {
      return Brick.To.Z;
    }
  }
  
  public bool Equals(SetBrick? obj)
  {
    return obj != null && Brick.Equals(obj.Brick);
  }

  public override int GetHashCode()
  {
    return Brick.GetHashCode();
  }
  
  public override string ToString()
  {
    StringBuilder b = new StringBuilder();
    b.Append(Brick);
    b.Append(" _{");
    bool first = true;
    foreach (SetBrick sb in Under)
    {
      if (first)
      {
        first = false;
      }
      else
      {
        b.Append(", ");
      }
      b.Append(sb.Brick.Id);
    }
    b.Append("} ^{");
    first = true;
    foreach (SetBrick sb in Above)
    {
      if (first)
      {
        first = false;
      }
      else
      {
        b.Append(", ");
      }
      b.Append(sb.Brick.Id);
    }
    b.Append("}");
    return b.ToString();
  }
  
  public bool IsOnlySupporter()
  {
    foreach (SetBrick a in Above)
    {
      if (a.Under.Count == 1)
      {
        return true;
      }
    }
    return false;
  }
  
  public int TransitiveOnlySupporter()
  {
    ISet<SetBrick> removed = new HashSet<SetBrick>();
    removed.Add(this);
    foreach (SetBrick a in Above)
    {
      a.removeBrickIfUnsupported(removed);
    }
    return removed.Count - 1;
  }
  
  private void removeBrickIfUnsupported(ISet<SetBrick> removed)
  {
    if (Under.IsSubsetOf(removed))
    {
      removed.Add(this);
      foreach (SetBrick a in Above)
      {
        a.removeBrickIfUnsupported(removed);
      }
    }
  }
}

class Board
{
  public IList<SetBrick> Bricks;
  public IDictionary<Point2, IList<SetBrick>> Columns;
  
  public Board()
  {
    Bricks = new List<SetBrick>();
    Columns = new Dictionary<Point2, IList<SetBrick>>();
  }
  
  private ISet<SetBrick> findTops(IList<Point2> projection)
  {
    int z = 0;
    ISet<SetBrick> tops = new HashSet<SetBrick>();
    foreach (Point2 point in projection)
    {
      IList<SetBrick>? bricks;
      if (Columns.TryGetValue(point, out bricks))
      {
        SetBrick top = bricks[bricks.Count - 1];
        if (top.Top > z)
        {
          tops.Clear();
          z = top.Top;
          tops.Add(top);
        } else if (top.Top == z)
        {
          tops.Add(top);
        }
      }
    }
    return tops;
  }
  
  private Brick moveDown(Brick brick, ISet<SetBrick> tops)
  {
    int z = 1;
    foreach (SetBrick b in tops)
    {
      z = b.Top + 1;
      break;
    }
    return brick.DownTo(z);
  }
  
  private void addToBoard(SetBrick brick, IList<Point2> projection)
  {
    Bricks.Add(brick);
    foreach (Point2 point in projection)
    {
      IList<SetBrick>? bricks;
      if (Columns.TryGetValue(point, out bricks))
      {
        bricks.Add(brick);
      }
      else
      {
        bricks = new List<SetBrick>();
        bricks.Add(brick);
        Columns[point] = bricks;
      }
    }
    foreach (SetBrick sb in brick.Under)
    {
      sb.Above.Add(brick);
    }
  }
  
  public void SetBrick(Brick brick)
  {
    IList<Point2> projection = brick.Projection();
    ISet<SetBrick> tops = findTops(projection);
    Brick down = moveDown(brick, tops);
    ISet<SetBrick> above = new HashSet<SetBrick>();
    SetBrick sb = new SetBrick(down, tops, above);
    addToBoard(sb, projection);
  }
}

class Program
{
  private static Point3 parsePoint3(string line)
  {
    string[] xyz = line.Split(',');
    int X = Int32.Parse(xyz[0]);
    int Y = Int32.Parse(xyz[1]);
    int Z = Int32.Parse(xyz[2]);
    return new Point3(new Point2(X, Y), Z);
  }

  private static Brick parseBrick(int id, string line)
  {
    string[] p1p2 = line.Split('~');
    Point3 p1 = parsePoint3(p1p2[0]);
    Point3 p2 = parsePoint3(p1p2[1]);
    return new Brick(id, p1, p2);
  }

  private static List<Brick> parseBricks(string fileName)
  {
    string content = File.ReadAllText(fileName).Trim();
    string[] lines = content.Split('\n');
    List<Brick> bricks = new List<Brick>();
    int id = 0;
    foreach (string line in lines)
    {
      bricks.Add(parseBrick(id, line));
      id++;
    }
    return bricks;
  }
  
  static void Main(string[] args)
  {
    List<Brick> bricks = parseBricks(args[0]);
    bricks.Sort((x, y) => x.From.Z - y.From.Z);
    // Console.WriteLine(bricks);
    
    Board board = new Board();
    
    foreach (Brick brick in bricks)
    {
      board.SetBrick(brick);
    }
    
    int canDisintegrate = 0;
    int transitivelyDisintegrate = 0;
    foreach (SetBrick sb in board.Bricks)
    {
      if (!sb.IsOnlySupporter())
      {
        canDisintegrate++;
      }
      transitivelyDisintegrate += sb.TransitiveOnlySupporter();
      // Console.WriteLine($"{sb}");
    }
    Console.WriteLine(
      $"{canDisintegrate} {transitivelyDisintegrate}");
  }
}
