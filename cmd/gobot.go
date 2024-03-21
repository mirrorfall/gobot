/*
Copyright © 2024 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"log"
	"os"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	TeleToken = os.Getenv("TELE_TOKEN")
)

// gobotCmd represents the gobot command
var gobotCmd = &cobra.Command{
	Use:     "gobot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("gobot called")

		gobot, err := telebot.NewBot(telebot.Settings{
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * 60},
			URL:    "",
		})

		if err != nil {
			log.Fatalf("Error creating new bot: %s", err)
			return
		}

		gobot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Print(m.Message().Payload, m.Text())

			message := m.Text()

			switch message {
			case "hello":
				m.Send("Hello, Human!")
			case "bye":
				m.Send("Goodbye, Human!")
			default:
				m.Send("I don't understand")
			}

			return err
		})
		gobot.Start()
	},
}

func init() {
	rootCmd.AddCommand(gobotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// gobotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// gobotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
