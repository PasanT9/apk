package main

import (
	"database/sql"
	"fmt"
	"io/ioutil"

	_ "github.com/lib/pq"
)

func main() {
	con_Str := "host=wso2apk-db-service port=5432 user=wso2carbon password=wso2carbon dbname=WSO2AM_DB sslmode=disable"

	conn, MyError := sql.Open("postgres", con_Str)
	if MyError != nil {
		panic(MyError)
	}
	fmt.Println("Connection successfully established!")
	_, MyError = conn.Exec("CREATE TABLE IF NOT EXISTS podstatus (time TIMESTAMPTZ,data TEXT)")
	if MyError != nil {
		panic(MyError)
	}
	fmt.Println("Table successfully created!")

	fileContent, err := ioutil.ReadFile("/var/log/pods.txt")
	if err != nil {
		panic(err)
	}

	insertData := `
        INSERT INTO podstatus (time, data)
        VALUES (NOW(), $1)`
	_, MyError = conn.Exec(insertData, fileContent)
	if MyError != nil {
		panic(MyError)
	}
	fmt.Println("Data successfully inserted!")
	conn.Close()
}
