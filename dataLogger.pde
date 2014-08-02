//import java.util.Date;
//import java.text.DateFormat;
//import java.text.SimpleDateFormat;
//import java.util.Calendar;
//
//static final String MOUSE_PRESSED = "MOUSE_PRESSED";
//static final String MOUSE_RELEASED = "MOUSE_RELEASED";
//static final String MOUSE_DRAGGED = "MOUSE_DRAGGED";
//static final String MOUSE_WHEEL = "MOUSE_WHEEL";
//PrintWriter output;
//
//void dataLog (String property,float value)
//{
//  String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(Calendar.getInstance().getTime());
//  //myFileWriter.writeEventToFile(timeStamp,MOUSE_PRESSED);
//  output.println(property+","+value+","+timeStamp);
//  output.flush();
//}
//
//void dataLoggerInit(String fileName)
//{
//  output = createWriter(fileName);
//}
//
//void dataLoggerClose()
//{
//  output.close();
//}

Table table;
boolean studyDone = false;

void dataLoggerInit() {

  table = new Table();
  
  table.addColumn("id");
  table.addColumn("timeStamp");
  table.addColumn("xTouch");
  table.addColumn("yTouch"); 
  //saveTable(table, "\\sdcard\\new.csv");
}

void logData(int xT, int yT) {
  String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(Calendar.getInstance().getTime());
  TableRow newRow = table.addRow();
  newRow.setInt("id", table.getRowCount() - 1);
  newRow.setString("timeStamp", timeStamp );
  newRow.setInt("xTouch", xT);
  newRow.setInt("yTouch", yT);
} 

void saveLoggedData() { 
  saveTable(table, "//sdcard/charAnim/new.csv");
}

