# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Book.delete_all
Page.delete_all

b = Book.create( {:title => "This Old Man", :image_directory => "this-old-man", :image_only => 1} )

Page.create({:book_id => b.id, 
             :page_num => 1, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 2, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 3, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 4, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 5, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 6, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 7, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 8, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 9, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 10, 
             :page_text => ""})
             
t = Book.create( {:title => "Goldilocks and the Three Bears", :image_directory => "the-three-bears"} )
Page.create({:book_id => t.id,
                          :page_num => 1,
                          :page_text => ""})
Page.create({:book_id => t.id,
                         :page_num => 2,
                         :page_text => "Once upon a time there were three bears -- a great big papa bear, a middle-sized mama bear, and a wee little baby bear.\nThey lived in a little house in the forest."
                         })
Page.create({:book_id => t.id,
                          :page_num => 3,
                          :page_text => "And they had three chairs -- a great big chair for the papa bear, a middle-sized chair for the mama bear, and a wee little chair for the baby bear."
                          })
Page.create({:book_id => t.id,
                         :page_num => 4,
                         :page_text => "And upstairs there were three beds -- a great big bed for the papa bear, a middle-sized bed for the mama bear, and a wee little bed for the baby bear."
                         })
Page.create({:book_id => t.id,
                          :page_num => 5,
                          :page_text => "One morning the mama bear made some porridge for breakfast."
                          })
Page.create({:book_id => t.id,
                         :page_num => 6,
                         :page_text => "She filled a great big bowl for the papa bear, a middle-sized bowl for the mama bear, and a wee little bowl for the baby bear."
                         })
Page.create({:book_id => t.id,
                          :page_num => 7,
                          :page_text => "But the porridge was too hot to eat, so the three bears went out for a walk in the forest."
                          })
Page.create({:book_id => t.id,
                         :page_num => 8,
                         :page_text => "That same morning a little girl called Goldilocks was walking through the woods.\nShe came to the three bears\' house. And she knocked on the door, but nobody called, \"Come in.\" So she opened the door and went in."
                         })
Page.create({:book_id => t.id,
                          :page_num => 9,
                          :page_text => "Goldilocks saw the three chairs. She sat in the great big chair. It was too hard. The middle-sized chair was too soft. The baby chair was just right -- but it broke when she sat on it."
                          })
Page.create({:book_id => t.id,
                        :page_num => 10,
                        :page_text => "Now Goldilocks spied the porridge.\n\"I am hungry,\" she said.\nSo she tasted the porridge."
                        })
Page.create({:book_id => t.id,
                         :page_num => 11,
                         :page_text => "The porridge in the big bowl was too hot.\n The porridge in the middle-sized bowl was too cold.\n The porridge in the wee little bowl was just right, so she ate it all up."
                         })
Page.create({:book_id => t.id,
                        :page_num => 12,
                        :page_text => "Then Goldilocks went upstairs and tried the beds."
                        })
Page.create({:book_id => t.id,
                         :page_num => 13,
                         :page_text => "The great big bed was too hard.\nThe middle-sized bed was too soft."
                         })
Page.create({:book_id => t.id,
                        :page_num => 14,
                        :page_text => "But the wee little bed was oh, so nice! So Goldilocks lay down and went to sleep."
                        })
Page.create({:book_id => t.id,
                         :page_num => 15,
                         :page_text => "Then home through the forest and back to their house came the three bears -- the great big bear, the middle-sized bear, and the wee little baby bear."
                         })
Page.create({:book_id => t.id,
                        :page_num => 16,
                        :page_text => "The moment they stepped into the house they saw that someone had been there.\n\"Humph!\" said the papa bear in his great big voice. \"Someone has been sitting in my chair!\""
                        })
Page.create({:book_id => t.id,
                         :page_num => 17,
                         :page_text => "\"Land sakes!\" said the mama bear in her middle-sized voice. \"Someone has been sitting in my chair.\"\n\"Oh dear!\" cried the baby bear in his wee little voice. \"Someone has been sitting in my chair, and has broken it all to bits.\""
                         })
Page.create({:book_id => t.id,
                        :page_num => 18,
                        :page_text => "Then they all looked at the table.\n\"Humph,\" said the papa bear in his great big voice. \"Someone has been tasting my porridge.\"\n\"And someone has been tasting my porridge,\" said the mama bear."
                        })
Page.create({:book_id => t.id,
                         :page_num => 19,
                         :page_text => "\"Someone has eaten my porridge all up,\" said the baby bear sadly. \nThen up the stairs went the three bears..."
                         })
Page.create({:book_id => t.id,
                        :page_num => 20,
                        :page_text => "...with a thump thump thump...\n...and a trot trot trot...\n ...and a skippity-skip-skip. (That was the wee little tiny bear.)"
                        })
Page.create({:book_id => t.id,
                         :page_num => 21,
                         :page_text => "\"Humph,\" said the papa bear in his great big voice. \"Someone has been sleeping in my bed!\"\n\"And someone has been sleeping in my bed,\" said the mama bear.\n\"Oh dear!\" cried the baby bear in his wee little voice. \"Someone has been sleeping in my bed, and here she is right now!\""
                         })
Page.create({:book_id => t.id,
                        :page_num => 22,
                        :page_text => "Goldilocks opened her eyes and she saw the three bears.\n\"Oh!\" said Goldilocks."
                        })
Page.create({:book_id => t.id,
                         :page_num => 23,
                         :page_text => "She was so surprised that she jumped right out of the window and she ran all the way home. \nAnd she never saw the house in the forest again."
                         })
 
t = Book.create( {:title => "Thomas Breaks a Promise", :image_directory => "thomas-breaks-a-promise"} )
Page.create({:book_id => t.id, 
             :page_num => 1, 
             :page_text => ""})
Page.create({:book_id => t.id, 
            :page_num => 2, 
            :page_text => "The seasons were changing on the Island of Sodor. The leaves had begun to change color, and the air was growing crisp. Thomas the Tank Engine was feeling restless.\n\"Summer is almost over, and I haven\'t had any real fun,\" he complained. \n\"You\'re a fussy little engine,\" replied Gordon. \"We\'re not here to have fun. We\'re here to work,\"\nWell, that didn\'t make Thomas feel any better.\n\"I\'d rather be fussy and fun than bossy and boring!\" he retorted."
            })
Page.create({:book_id => t.id, 
             :page_num => 3, 
             :page_text => "The next morning, Sir Topham Hatt called the engines together.\n\"We\'re opening a new branch line tomorrow,\" he told them. \"I need one of you to check the signals on the new line to see that they\'re all working properly. Who will volunteer?\""
             })
Page.create({:book_id => t.id, 
            :page_num => 4, 
            :page_text => "\"I will,\" Thomas piped up. \"I promise to check very carefully.\" Checking signals wasn\'t much fun, but it was better than being bossed around in the train yard.\n\"Off you go, then,\" said Sir Topham Hatt. \"And be sure to check every signal, Thomas. Safety is our first concern.\""
            })
Page.create({:book_id => t.id, 
             :page_num => 5, 
             :page_text => "Something about shiny new tracks always put Thomas in a good mood. He whistled merrily as he rolled along the new branch line. \"Checking signals is really useful,\" he thought. \"Safety is our first concern.\""
             })
Page.create({:book_id => t.id, 
            :page_num => 6, 
            :page_text => "Each time he saw a signal, Thomas made sure that the arm was in the right position. He also checked to see that the signal lamp was working, so it could be seen at night.\nIf the signal arm was down and the lamp was red, that meant danger on the tracks ahead.\nThere were hidden junctions..."
            })
Page.create({:book_id => t.id, 
             :page_num => 7, 
             :page_text => "...hanging rocks..."
             })
Page.create({:book_id => t.id, 
            :page_num => 8, 
            :page_text => "...dangerous curves..."
            })
Page.create({:book_id => t.id, 
             :page_num => 9, 
             :page_text => "...and steep hills..."})
Page.create({:book_id => t.id, 
           :page_num => 10, 
           :page_text => "Thomas had almost reached the end of the new branch line when he saw the sign for a carnival. there was nothing Thomas loved more than a carnival. Oh, how he would love to go!"
           })
Page.create({:book_id => t.id, 
            :page_num => 11, 
            :page_text => "\"If I hurry to the carnival now, I can check the rest of the signals later,\" he told himself. And with that, Thomas turned off and headed into the countryside."
            })
Page.create({:book_id => t.id, 
           :page_num => 12, 
           :page_text => "The carnival was splendid. There were games and rides and cotton candy. And there were lots of children.\n\"Look, it\'s Thomas!\" they cried, and ran to greet their favorite blue engine."
           })
Page.create({:book_id => t.id, 
            :page_num => 13, 
            :page_text => "When Thomas got back to the train yard, Sir Topham Hatt was waiting.\n\"You've been gone a long time, Thomas,\" he said. \"You must have done a very thorough job of checking the signals on the new branch line.\""
            })
Page.create({:book_id => t.id, 
           :page_num => 14, 
           :page_text => "\"Yes sir,\" peeped Thomas. But suddenly he realized that he\'d forgotten to go back and finish the job. He had broken his promise! But how could he tell that to Sir Topham Hatt?\n\"Good.\" Sir Topham Hatt beamed. \"Then everything is ready for tomorrow\'s grand opening.\""
           })
Page.create({:book_id => t.id, 
            :page_num => 15, 
            :page_text => "Thomas gulped. What if there was trouble? What if one of the unchecked signals didn\'t work?\n\"I know,\" thought Thomas. \"I\'ll get up very early tomorrow and go out to check the rest of the signals before the grand opening.\""
            })
Page.create({:book_id => t.id, 
           :page_num => 16, 
           :page_text => "That night, Percy was being loaded for his mail run when a call came into the station. Rain had washed out a section of track on the mail route. Percy would have to find a way around."
           })
Page.create({:book_id => t.id, 
            :page_num => 17, 
            :page_text => "\"Don\'t worry, Percy.\" Sir Toham Hatt smiled. \"You can take the new branch line.\"\nOff Percy went, pulling two big cars loaded with mail."
            })
Page.create({:book_id => t.id, 
           :page_num => 18, 
           :page_text => "The rain fell heavily. Each time Percy saw a red signal lamp, he slowed carefully until he had passed the dangerous spot. Then suddenly, in the dark, Percy passed another signal. The lamp was not lit, so he didn\'t see it until it was too late. The arm was down, for danger!"
           })
Page.create({:book_id => t.id, 
            :page_num => 19, 
            :page_text => "Percy slammed on his brakes, but the rain made the tracks slippery. And there it was ahead -- a very dangerous curve.\n\"Oh, no!\" cried Percy. He closed his eyes and did his best to hold on through the turn.\nCRASH! One of the mail cars flew off the tracks and was smashed to bits. Percy shivered with fear from his close call."
            })
Page.create({:book_id => t.id, 
           :page_num => 20, 
           :page_text => "The next morning, Thomas awoke and sneaked out of his shed. Then he saw Percy returning with Sir Topham Hatt.\n\"Percy has had a terrible fright,\" Sir Topham said sternly. \"He almost derailed because of a signal lamp that didn\'t work. How could such a thing have happened, Thomas?\""
           })
Page.create({:book_id => t.id, 
            :page_num => 21, 
            :page_text => "\"Oh sir! I\'m so sorry, sir,\" Thomas sputtered. And it all came rushing out -- about the carnival, and the children, and about how he\'d forgotten to go back and finish the job.\n\"I\'m sorry I broke my promise, sir,\" said Thomas sheepishly. \"I just wanted to be part of the fun, and then I forgot.\""
            })
Page.create({:book_id => t.id, 
           :page_num => 22, 
           :page_text => "\"There will be no fun for you for quite some time,\" Sir Topham Hatt scolded. \"Percy will run your branch line until you\'ve gone and checked every signal on my railway -- twice!\""
           })
Page.create({:book_id => t.id, 
            :page_num => 23, 
            :page_text => "And now, every time Thomas passes a signal, he checks it twice, just to be safe. Gordon likes to tease him. \"Fussy little Thomas certainly is fussy about signals.\"\n\"Peep, peep!\" says Thomas. \"Safety is our first concern.\""
            })

b = Book.create({ :title => "Little Red Riding Hood", :image_directory => "little-red-riding-hood" })
Page.create({:book_id => b.id, 
                         :page_num => 1, 
                         :page_text => "Once upon a time, there was a little girl who lived in a village near the forest.  Whenever she went out, the little girl wore a red riding cloak, so everyone in the village called her Little Red Riding Hood. \nOne morning, Little Red Riding Hood asked her mother if she could go to visit her grandmother as it had been awhile since they'd seen each other. \n\"That's a good idea,\" her mother said.  So they packed a nice basket for Little Red Riding Hood to take to her grandmother."})
Page.create({:book_id => b.id, 
                         :page_num => 2, 
                         :page_text => "When the basket was ready, the little girl put on her red cloak and kissed her mother goodbye. \n\"Remember, go straight to Grandma's house,\" her mother cautioned.  \"Don't dawdle along the way and please don't talk to strangers!  The woods are dangerous.\" \n\"Don't worry, mommy,\" said Little Red Riding Hood, \"I'll be careful.\""}) 
Page.create({:book_id => b.id, 
                         :page_num => 3, 
                         :page_text => "But when Little Red Riding Hood noticed some lovely flowers in the woods, she forgot her promise to her mother.  She picked a few, watched the butterflies flit about for awhile, listened to the frogs croaking and then picked a few more. \nLittle Red Riding Hood was enjoying the warm summer day so much, that she didn't notice a dark shadow approaching out of the forest behind her..."})
Page.create({:book_id => b.id, 
                         :page_num => 4, 
                         :page_text => "Suddenly, the wolf appeared beside her.\n\"What are you doing out here, little girl?\" the wolf asked in a voice as friendly as he could muster.\n\"I'm on my way to see my Grandma who lives through the forest, near the brook,\"  Little Red Riding Hood replied.\nThen she realized how late she was and quickly excused herself, rushing down the path to her Grandma's house.\nThe wolf, in the meantime, took a shortcut..."})
Page.create({:book_id => b.id, 
                         :page_num => 5, 
                         :page_text => "The wolf, a little out of breath from running, arrived at Grandma's and knocked lightly at the door.\n\"Oh thank goodness dear!  Come in, come in!  I was worried sick that something had happened to you in the forest,\" said Grandma thinking that the knock was her granddaughter.\nThe wolf let himself in.  Poor Granny did not have time to say another word, before the wolf gobbled her up!"})   
Page.create({:book_id => b.id, 
                         :page_num => 6, 
                         :page_text => "The wolf let out a satisfied burp, and then poked through Granny's wardrobe to find a nightgown that he liked.  He added a frilly sleeping cap, and for good measure, dabbed some of Granny's perfume behind his pointy ears.\nA few minutes later, Red Riding Hood knocked on the door.  The wolf jumped into bed and pulled the covers over his nose.  \"Who is it?\" he called in a cackly voice.\n\"It's me, Little Red Riding Hood.\"\n\"Oh how lovely!  Do come in, my dear,\" croaked the wolf."}) 
Page.create({:book_id => b.id, 
                         :page_num => 7, 
                         :page_text => "When Little Red Riding Hood entered the little cottage, she could scarcely recognize her Grandmother.\n\"Grandmother!  Your voice sounds so odd.  Is something the matter?\" she asked.\n\"Oh, I just have touch of a cold,\" squeaked the wolf adding a cough at the end to prove the point.\n\"But Grandmother!  What big ears you have,\" said Little Red Riding Hood as she edged closer to the bed.\"The better to hear you with, my dear,\" replied the wolf."})
Page.create({:book_id => b.id, 
                         :page_num => 8, 
                         :page_text => "\"But Grandmother!  What big eyes you have,\" said Little Red Riding Hood.\n\"The better to see you with, my dear,\" replied the wolf.\n\"But Grandmother!  What big teeth you have,\" said Little Red Riding Hood her voice quivering slightly.\n\"The better to eat you with, my dear,\" roared the wolf and he leapt out of the bed and began to chase the little girl."})
Page.create({:book_id => b.id, 
                         :page_num => 9, 
                         :page_text => "Almost too late, Little Red Riding Hood realized that the person in the bed was not her Grandmother, but a hungry wolf.\nShe ran across the room and through the door, shouting, \"Help!  Wolf!\" as loudly as she could.\nA woodsman who was chopping logs nearby heard her cry and ran towards the cottage as fast as he could.\nHe grabbed the wolf and made him spit out the poor Grandmother who was a bit frazzled by the whole experience, but still in one piece."})
Page.create({:book_id => b.id, 
                         :page_num => 10, 
                         :page_text => "\"Oh Grandma, I was so scared!\"  sobbed Little Red Riding Hood, \"I'll never speak to strangers or dawdle in the forest again.\"\n\"There, there, child.  You've learned an important lesson.  Thank goodness you shouted loud enough for this kind woodsman to hear you!\"\nThe woodsman knocked out the wolf and carried him deep into the forest where he wouldn't bother people any longer.\nLittle Red Riding Hood and her Grandmother had a nice lunch and a long chat."}) 

b = Book.create( {:title => "Pinboard-safari", :image_directory => "Pinboard-safari", :image_only => 1} )
Page.create({:book_id => b.id, 
             :page_num => 1, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 2, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 3, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 4, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 5, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 6, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 7, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 8, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 9, 
             :page_text => ""})
Page.create({:book_id => b.id, 
             :page_num => 10, 
             :page_text => ""})