local conf = {
	-- required openai api key
	openai_api_key = os.getenv("OPENAI_API_KEY"),
	-- api endpoint (you can change this to azure endpoint)
	openai_api_endpoint = "https://api.openai.com/v1/chat/completions",
	-- openai_api_endpoint = "https://$URL.openai.azure.com/openai/deployments/{{model}}/chat/completions?api-version=2023-03-15-preview",
	-- prefix for all commands
	cmd_prefix = "Gp",

	-- directory for storing chat files
	chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
	-- chat model (string with model name or table with model name and parameters)
	chat_model = { model = "gpt-3.5-turbo-16k", temperature = 0.7, top_p = 1 },
	-- chat model system prompt
	chat_system_prompt = "You are a general AI assistant.",
	-- chat user prompt prefix
	chat_user_prefix = "🗨:",
	-- chat assistant prompt prefix
	chat_assistant_prefix = "🤖:",
	-- chat topic generation prompt
	chat_topic_gen_prompt = "Summarize the topic of our conversation above"
		.. " in two or three words. Respond only with those words.",
	-- chat topic model (string with model name or table with model name and parameters)
	chat_topic_gen_model = "gpt-3.5-turbo-16k",
	-- explicitly confirm deletion of a chat file
	chat_confirm_delete = true,
	-- conceal model parameters in chat
	chat_conceal_model_params = true,
	-- local shortcuts bound to the chat buffer
	-- (be careful to choose something which will work across specified modes)
	chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
	chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
	chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>n" },

	-- command config and templates bellow are used by commands like GpRewrite, GpEnew, etc.
	-- command prompt prefix for asking user for input
	command_prompt_prefix = "🤖 ~ ",
	-- command model (string with model name or table with model name and parameters)
	command_model = { model = "gpt-3.5-turbo-16k", temperature = 0.7, top_p = 1 },
	-- command system prompt
	command_system_prompt = "You are an AI that strictly generates just the formated final code.",

	-- templates
	template_selection = "I have the following code from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
	template_rewrite = "I have the following code from {{filename}}:"
		.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
		.. "\n\nRespond just with the snippet of code that should be inserted.",
	template_command = "{{command}}",

	-- https://platform.openai.com/docs/guides/speech-to-text/quickstart
	-- Whisper costs $0.006 / minute (rounded to the nearest second)
	-- by eliminating silence and speeding up the tempo of the recording
	-- we can reduce the cost by 50% or more and get the results faster
	-- directory for storing whisper files
	whisper_dir = "/tmp/gp_whisper",
	-- multiplier of RMS level dB for threshold used by sox to detect silence vs speech
	whisper_silence = "1.5",
	-- whisper max recording time (mm:ss)
	whisper_max_time = "05:00",
	-- whisper tempo (1.0 is normal speed)
	whisper_tempo = "1.75",

	-- example hook functions (see Extend functionality section in the README)
	hooks = {
		InspectPlugin = function(plugin, params)
			print(string.format("Plugin structure:\n%s", vim.inspect(plugin)))
			print(string.format("Command params:\n%s", vim.inspect(params)))
		end,

		-- GpImplement finishes the provided selection/range based on comments in the code
		Implement = function(gp, params)
			local template = "I have the following code from {{filename}}:\n\n"
				.. "```{{filetype}}\n{{selection}}\n```\n\n"
				.. "Please finish the code above according to comment instructions."
				.. "\n\nRespond just with the snippet of code that should be inserted."

			gp.Prompt(
				params,
				gp.Target.rewrite,
				nil, -- command will run directly without any prompting for user input
				gp.config.command_model,
				template,
				gp.config.command_system_prompt
			)
		end,

		-- your own functions can go here, see README for more examples like
		-- :GpExplain, :GpUnitTests.., :GpBetterChatNew, ..

	},
}

-- call setup on your config
require("gp").setup(conf)

-- shortcuts might be setup here (see Usage > Shortcuts in Readme)
