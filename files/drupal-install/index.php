<html>
  <head>
    <title>Install Drupal</title>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.12/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="http://aehlke.github.io/tag-it/js/tag-it.js" type="text/javascript" charset="utf-8"></script>

    <link type="text/css" rel="stylesheet" href="global.css" media="all" />

    <script type="text/javascript">
      jQuery( document ).ready(function( $ ) {
        $('#exclude_form input[name="distribution"]').tagit({

          // Options
          fieldName: "distribution",
          availableTags: ["drupal", "commerce_kickstart", "openatrium", "commons", "openchurch", "openpublic", "opendeals", "openfolio", "openenterprise", "bear", "openoutreach", "julio", "agov", "l10n_install", "opigno_lms"],
          autocomplete: {delay: 0, minLength: 2},
          showAutocompleteOnFocus: false,
          removeConfirmation: false,
          caseSensitive: false,
          allowDuplicates: false,
          allowSpaces: false,
          readOnly: false,
          tagLimit: 1,
          singleField: true,
          singleFieldDelimiter: ',',
          singleFieldNode: null,
          tabIndex: null,
          placeholderText: 'Drupal Distribution',

          // Events
          beforeTagAdded: function(event, ui) {
              console.log(ui.tag);
          },
          afterTagAdded: function(event, ui) {
              console.log(ui.tag);
          },
          beforeTagRemoved: function(event, ui) {
              console.log(ui.tag);
          },
          onTagExists: function(event, ui) {
              console.log(ui.tag);
          },
          onTagClicked: function(event, ui) {
              console.log(ui.tag);
          },
          onTagLimitExceeded: function(event, ui) {
              console.log(ui.tag);
          }

        });
        $('#exclude_form input[name="domain"]').tagit({

          // Options
          fieldName: "domain",
          availableTags: [],
          autocomplete: {delay: 0, minLength: 2},
          showAutocompleteOnFocus: false,
          removeConfirmation: false,
          caseSensitive: false,
          allowDuplicates: false,
          allowSpaces: false,
          readOnly: false,
          tagLimit: 1,
          singleField: true,
          singleFieldDelimiter: ',',
          singleFieldNode: null,
          tabIndex: null,
          placeholderText: 'example.com',

          // Events
          beforeTagAdded: function(event, ui) {
              console.log(ui.tag);
          },
          afterTagAdded: function(event, ui) {
              console.log(ui.tag);
          },
          beforeTagRemoved: function(event, ui) {
              console.log(ui.tag);
          },
          onTagExists: function(event, ui) {
              console.log(ui.tag);
          },
          onTagClicked: function(event, ui) {
              console.log(ui.tag);
          },
          onTagLimitExceeded: function(event, ui) {
              console.log(ui.tag);
          }

        });
      });
    </script>
  </head>
  <body>
    <?php $msg = isset($_SESSION['msg']) ? $_SESSION['msg'] : 'Enter Drupal distribution to install: https://drupal.org/project/project_distribution'; ?>
    <div id="exclude_form">
      <form action="index.php">
        <input type="text" name="domain" value="" placeholder="example.com">
        <input type="text" name="distribution" value="" placeholder="Drupal Distribution">
        <input type="submit" value="Install">
        <div class="error-hint"><?php echo $msg; ?></div>

      </form>
    </div>

    <?php

      if (isset($_GET['distribution']) && !empty($_GET['distribution'])) {

        // Purge cache
        $domain = $_GET['domain'];

        $distribution = $_GET['distribution'];

        // Write to config
        $conf_file = '/var/log/drupal-install';
        $msg = "Drupal profile $distribution installed on $domain\n";

        $handle = fopen($conf_file, 'a');
        fwrite($handle, $msg);
        fclose($handle);

        // run
        #$command = escapeshellcmd("sudo /root/puppet-drupalstack/lib/vhost_deploy.sh -a $domain -d $distribution > /dev/null 2>/dev/null &");
        #$command = escapeshellarg("sudo /root/puppet-drupalstack/lib/vhost_deploy.sh -a $domain -d $distribution");
        $command = "'sudo /root/puppet-drupalstack/lib/vhost_deploy.sh -a $domain -d $distribution'";

        $exec = "sudo php /root/puppet-drupalstack/lib/daemonize.php $command";

        // Write to config
        $conf_file = '/var/log/drupal-install';
        $msg = "debug command: $exec\n";

        $handle = fopen($conf_file, 'a');
        fwrite($handle, $msg);
        fclose($handle);


        $output = exec($exec);
        #exec($command);

        // @todo - session won't work but you get the idea
        $_SESSION['msg'] = $msg;
      }
    ?>

  </body>
</html>