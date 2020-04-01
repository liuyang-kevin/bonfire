EN | [PT](https://github.com/RafaelBarbosatec/bonfire/blob/master/README_PT.md)

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://github.com/RafaelBarbosatec/bonfire)
[![Powered by Flame](https://img.shields.io/badge/Powered%20by-%F0%9F%94%A5-orange.svg)](https://flame-engine.org)
[![Flutter](https://img.shields.io/badge/Made%20with-Flutter-blue.svg)](https://flutter.dev/)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)
[![pub package](https://img.shields.io/pub/v/bonfire.svg)](https://pub.dev/packages/bonfire)

![](https://github.com/RafaelBarbosatec/bonfire/blob/master/media/bonfire.gif)

# Bonfire

Build RPG-type games or similar by exploring the power of [FlameEngine](https://flame-engine.org/)!

![](https://github.com/RafaelBarbosatec/bonfire/blob/master/media/video_example.gif)

[Download Demo](https://github.com/RafaelBarbosatec/bonfire/raw/master/demo/demo.apk)

You can find the complete code for this example [here](https://github.com/RafaelBarbosatec/bonfire/tree/master/example).

## Summary
1. [How it works?](#como-funciona)
   - [Map](#map)
   - [Decorations](#decorations)
   - [Enemy](#enemy)
   - [Player](#player)
   - [Interface](#interface)
   - [Joystick](#joystick)
4. [Useful components](#componentes-úteis)
3. [Next steps](#próximos-passos)

## How it works?

This tool was built using the resources of the [FlameEngine](https://flame-engine.org/) and all of them are available to be used in addition to those implemented by the Bonfire. Because of this, it is recommended to take a look at [FlameEngine](https://flame-engine.org/) before starting to play with Bonfire.

To run the game with Bonfire, just use the widget:

```dart
@override
  Widget build(BuildContext context) {
    return BonfireWidget(
      joystick: MyJoystick(), // required
      map: DungeonMap.map(), // required
      player: Knight(), // If the player is not specified, the directional pad of the joystick will have the function of exploring the map, this will be very useful to assist in the construction of the map.
      interface: KnightInterface(),
      decorations: DungeonMap.decorations(),
      enemies: DungeonMap.enemies(),
      background: BackgroundColorGame(Colors.blueGrey[900]),
      constructionMode: false, // If true activates hot reload to facilitate map construction and draw grid.
      listener: (context, game) {
        // TODO ANYTHING
      },
    );
  }
```

Description of components and organization:

![](https://github.com/RafaelBarbosatec/bonfire/blob/master/media/game_diagram.png)

### Map
Represents the map (world) of the game.

It consists of a matrix of squares (Tiles), which together form your world [(look)](https://www.mapeditor.org/img/screenshot-terrain.png). You currently assemble this matrix manually, as we can see in this [example](https://github.com/RafaelBarbosatec/bonfire/blob/master/example/lib/map/dungeon_map.dart), but in the future it will have support for loading maps assembled with [Tiled](https://www.mapeditor.org/).

There is a component ready and its name is:
```dart
MapWorld(List<Tile>())
```

In it we pass the list of Tiles that will mount our map.

```dart
Tile(
   'tile/wall_left.png', // image that represents this Tile.
   Position(positionX, positionY), // position on the map where it will be rendered.
   collision: true, // if it has a collision, that is, neither the player nor enemies will pass through it (ideal for walls and obstacles).
   size: 16 // Tile size, in this case 16x16
)
```

### Decorations
It represents anything you want to add to the scenario, it can be a simple "barrel" in the middle of the path or even an NPC that you can use to interact with your player.

You can create your decoration like this:

```dart
GameDecoration(
  spriteImg: 'itens/table.png', // image that will be rendered.
  initPosition: getRelativeTilePosition(10, 6), // position in the world to be positioned.
  width: 32,
  height: 32,
  withCollision: true, // enables default collision.
  collision: Collision( // use if you want to customize the collision area.
    width: 18,
    height: 32,
  ),
//  animation: FlameAnimation(), // if you want to add something animated you can pass your animation here and not pass the 'spriteImg'.
//  frontFromPlayer: false // caso queira forçar que esse elemento fique por cima do player ao passar por ele.
)
```   

Or you can also create your own class by simply extending ```GameDecoration``` and adding the behaviors you want using ```update``` and / or ```render```, as done in this [example](https://github.com/RafaelBarbosatec/bonfire/blob/master/example/lib/decoration/chest.dart).

In this component as in all others, you have access to the ```BuildContext``` of the Widget that renders the game, so it is possible to display dialogs, overlays, among other Flutter components to display something on the screen.

### Enemy
It is used to represent those who want to kill you :-). In this component there are actions and movements ready to be used and configured if you want. However, if you want something different you will have complete freedom to customize your actions and movements.

To create your enemy you must create a class that represents and extends ```Enemy``` as in this [example](https://github.com/RafaelBarbosatec/bonfire/blob/master/example/lib/enemy/goblin.dart). In the constructor you will have these configuration parameters:

```dart
Goblin() : super(
          animationIdleRight: FlameAnimation(), //required
          animationIdleLeft: FlameAnimation(), // required
          animationIdleTop: FlameAnimation(),
          animationIdleBottom: FlameAnimation(),
          animationRunRight: FlameAnimation(), //required
          animationRunLeft: FlameAnimation(), //required
          animationRunTop: FlameAnimation(),
          animationRunBottom: FlameAnimation(),
          initDirection: Direction.right,
          initPosition: Position(x,y),
          width: 25,
          height: 25,
          speed: 1.5,
          life: 100,
          collision: Collision(), // If you want to edit collision area
        );
```   

After these steps, your enemy is ready, but he will do nothing but stand still. To add movements to it, you will need to override the ```Update``` method and implement its behavior there.
There are already some ready-made actions that you can use as you can see in this [example](https://github.com/RafaelBarbosatec/bonfire/blob/master/example/lib/enemy/goblin.dart), are they:


```dart

//basic movements
void moveBottom({double moveSpeed})
void moveTop({double moveSpeed})
void moveLeft({double moveSpeed})
void moveRight({double moveSpeed})
    
  // According to the radius passed by parameter, the enemy will search and observe the player.
  void seePlayer(
        {
         Function(Player) observed,
         Function() notObserved,
         int visionCells = 3,
        }
  )
  
  // According to the configured radius, the enemy will search for the player, if it finds it, it will move towards the player and when it gets close, the 'closePlayer' method will be triggered.
  void seeAndMoveToPlayer(
     {
      Function(Player) closePlayer,
      int visionCells = 3
     }
  )
 
  // Performs a physical attack on the player inflicting the configured damage with the configured frequency. You can add animations to represent that attack.
  void simpleAttackMelee(
     {
       @required double damage,
       @required double heightArea,
       @required double widthArea,
       int interval = 1000,
       FlameAnimation.Animation attackEffectRightAnim,
       FlameAnimation.Animation attackEffectBottomAnim,
       FlameAnimation.Animation attackEffectLeftAnim,
       FlameAnimation.Animation attackEffectTopAnim,
     }
  )
  
  // Performs a ranged attack. A 'FlyingAttackObject' will be added to the game, which is a component that will move around the map in the configured direction and will cause damage to those who reach or destroy themselves when hitting barriers.
  void simpleAttackRange(
     {
       @required FlameAnimation.Animation animationRight,
       @required FlameAnimation.Animation animationLeft,
       @required FlameAnimation.Animation animationTop,
       @required FlameAnimation.Animation animationBottom,
       @required FlameAnimation.Animation animationDestroy,
       @required double width,
       @required double height,
       double speed = 1.5,
       double damage = 1,
       Direction direction,
       int interval = 1000,
     }
  )
  
  // According to the configured radius, the enemy will search for the player, if it finds it, it will position itself to execute a ranged attack. Upon reaching this position, it will notify by the 'positioned' function.
  void seeAndMoveToAttackRange(
      {
        Function(Player) positioned,
        int visionCells = 5
      }
  )
  
  // Displays the damage value in the game with an animation.
   void showDamage(
      double damage,
      {
         TextConfig config = const TextConfig(
           fontSize: 10,
           color: Colors.white,
         )
      }
    )
    
    // If you need to know which direction the player is in relation to you.
    Direction directionThatPlayerIs()
    
    // If you want to add a short animation (animation without loop, it runs only once).
    void addFastAnimation(FlameAnimation.Animation animation)
    
    // If you want to inflict damage on him.
    void receiveDamage(double damage)
    
    // If you want to add life.
    void addLife(double life)
    
    // Add in 'render' if you want to draw a collision area.
    void drawPositionCollision(Canvas canvas)

    // Draw the standard life bar. It must be used by overriding the 'render' method.
    void drawDefaultLifeBar(
      Canvas canvas,
      {
        bool drawInBottom = false,
        double padding = 5,
        double strokeWidth = 2,
      }
    )
    
```

### Player
It represents your character. It also has actions and movements ready to be used.

To create your player, you must create a class that represents it and extends ```Player``` as in this [example](https://github.com/RafaelBarbosatec/bonfire/blob/master/example/lib/player/knight.dart). In the constructor you will have the following configuration parameters:

```dart
Knight() : super(
          animIdleLeft: FlameAnimation(), // required
          animIdleRight: FlameAnimation(), //required
          animIdleTop: FlameAnimation(),
          animIdleBottom: FlameAnimation(),
          animRunRight: FlameAnimation(), //required
          animRunLeft: FlameAnimation(), //required
          animRunTop: FlameAnimation(),
          animRunBottom: FlameAnimation(),
          width: 32,
          height: 32,
          initPosition: Position(x,y), //required
          initDirection: Direction.right,
          life: 200,
          speed: 2.5,
          collision: Collision(), // If you want to edit collision area
        );
```   

In the player, you can receive the actions that have been configured on your Joystick (this configuration you will see in more detail ahead) overriding the method:

```dart
  @override
  void joystickAction(int action) {}
```

When you feel the touch on these joystick actions, you can perform other actions. As with the enemy, here we also have some actions ready to be used:

```dart
  
  // Performs a physical attack on the enemy inflicting configured damage. You can add animations to represent that attack.
  void simpleAttackMelee(
     {
       @required FlameAnimation.Animation attackEffectRightAnim,
       @required FlameAnimation.Animation attackEffectBottomAnim,
       @required FlameAnimation.Animation attackEffectLeftAnim,
       @required FlameAnimation.Animation attackEffectTopAnim,
       @required double damage,
       double heightArea = 32,
       double widthArea = 32,
     }
  )
  
  // Executa um ataque a distância. Será adicionado ao game um 'FlyingAttackObject' que é um componente que se moverá pelo mapa na direção configurada e causará dano a aquele que atingir ou se destruir ao se bater em barreiras.
  void simpleAttackRange(
     {
       @required FlameAnimation.Animation animationRight,
       @required FlameAnimation.Animation animationLeft,
       @required FlameAnimation.Animation animationTop,
       @required FlameAnimation.Animation animationBottom,
       @required FlameAnimation.Animation animationDestroy,
       @required double width,
       @required double height,
       double speed = 1.5,
       double damage = 1,
     }
  )
  
  // Exibe valor do dano no game com uma animação.
   void showDamage(
      double damage,
      {
         TextConfig config = const TextConfig(
           fontSize: 10,
           color: Colors.white,
         )
      }
    )
    
    // De acordo com o raio passado por parâmetro o player irá procurar e observar inimigos.
    void seeEnemy(
       {
          Function(List<Enemy>) observed,
          Function() notObserved,
          int visionCells = 3,
       }
    )
    
    // Adicione em 'render' caso deseje desenhar área de colisão.
    void drawPositionCollision(Canvas canvas)
    
    // Caso deseje adicionar uma animação curta (animação sem loop, ele executa somente uma vez).
    void addFastAnimation(FlameAnimation.Animation animation)
    
    // Caso deseje infligir dano a ele.
    void receiveDamage(double damage)
    
    // Caso deseje adicionar vida.
    void addLife(double life)
  
```

### Interface
É um meio disponibilizado para você desenhar a interface do game, como barra de vida, stamina, configurações, ou seja, qualquer outra coisa que queira adicionar à tela.

Para criar sua interface você deverá criar uma classe e extender de ```GameInterface``` como nesse [exemplo](https://github.com/RafaelBarbosatec/bonfire/blob/master/example/lib/player/knight_interface.dart). 

Sobrescrevendo os métodos ```Update``` e ```Render``` você poderá desenhar sua interface utilizando Canvas ou utilizando componentes disponibilizados pelo [FlameEngine](https://flame-engine.org/).

### Joystick
É responsável por controlar seu personagem. Existe um componente totalmente pronto e configurável para você personalizar o visual e adicionar a quantidade de ações que achar necessário, ou você também poderá criar o seu próprio joystick utilizando nossa classe abstrata.

Também temos um componente prontinho para te ajudar nessa etapa, mas se quiser construir o seu pŕoprio basta extender de ```JoystickController``` e notificar os eventos utilizando o ```joystickListener``` que estará disponível para você.

O componente default que existe para ser utilizado é configurável da seguinte maneira:

```dart

      Joystick(
        pathSpriteBackgroundDirectional: 'joystick_background.png', //(required) imagem do background do direcional.
        pathSpriteKnobDirectional: 'joystick_knob.png', //(required) imagem da bolinha que indica a movimentação do direcional.
        sizeDirectional: 100, // tamanho do direcional.
        marginBottomDirectional: 100,
        marginLeftDirectional: 100,
        actions: [         // Você adicionará quantos actions desejar. Eles ficarão posicionados sempre no lado direito da tela e você poderá definir em que posição deseja que cada um fique.
          JoystickAction(
            actionId: 0,      //(required) Id que irá ser acionado ao Player no método 'void joystickAction(int action) {}' quando for clicado.
            pathSprite: 'joystick_atack.png',     //(required) imagem da ação.
            pathSpritePressed : 'joystick_atack.png', // caso queira, poderá adicionar uma imagem que será exibida quando for clicado.
            size: 80,
            marginBottom: 50,
            marginRight: 50,
            align = JoystickActionAlign.BOTTOM // eles sempre estarão alinhados a direita da tela, com possibilidades de definir para cima ou para baixo (JoystickActionAlign.TOP/JoystickActionAlign.BOTTOM).
          ),
          JoystickAction(
            actionId: 1,
            pathSprite: 'joystick_atack_range.png',
            size: 50,
            marginBottom: 50,
            marginRight: 160,
            align = JoystickActionAlign.BOTTOM
          )
        ],
      )
      
```

Veja o [exemplo](https://github.com/RafaelBarbosatec/bonfire/blob/master/example/lib/main.dart).

### OBS:
Esses elementos do game utilizam o mixin ´HasGameRef´, então você terá acesso a todos esses componentes (Map,Decoration,Enemy,Player,...) internamente, que serão úteis para a criação de qualquer tipo de interação ou adição de novos componentes programaticamente.

Se for necessário obter a posição de um componente para ser utilizado como base para adicionar outros componentes no mapa ou coisa do tipo, sempre utilize o ```positionInWorld```, ele é a posição atual do componente no mapa. A variável ```position``` refere-se a posição na tela para ser renderizado.

## Componentes úteis

São componentes que executam algum tipo de comportamento e podem ser úteis. Assim como qualquer outro componente criado por você que extenda de ```Component``` do flame ou ```AnimatedObject``` do Bonfire, você pode utilizá-lo no seu game programaticamente dessa forma:

```dart
this.gameRef.add(COMPONENTE);
```

Os componentes disponíveis até o momento são:

```dart

// Componente que executa sua animação uma única vez e logo após se destrói.
AnimatedObjectOnce(
   {
      Rect position,
      FlameAnimation.Animation animation,
      VoidCallback onFinish,
      bool onlyUpdate = false,
   }
)

// Esse componente assim como o anterior, pode executar sua animação e se destruir ou continuar executando em loop. Mas o grande diferencial é que ele é executado seguindo a posição de um outro componente como um player, enemy ou decoration.
AnimatedFollowerObject(
    {
      FlameAnimation.Animation animation,
      AnimatedObject target,
      Position positionFromTarget,
      double height = 16,
      double width = 16,
      bool loopAnimation = false
   }
)

// Componente que anda em determinada direção configurada em uma determinada velocidade também configurável e somente para ao atingir um inimigo ou player infligindo dano, ou pode se destruir ao atigir algum componente que tenha colisão (Tiles,Decorations).
FlyingAttackObject(
   {
      @required this.initPosition,
      @required FlameAnimation.Animation flyAnimation,
      @required Direction direction,
      @required double width,
      @required double height,
      FlameAnimation.Animation this.destroyAnimation,
      double speed = 1.5,
      double damage = 1,
      bool damageInPlayer = true,
      bool damageInEnemy = true,
  }
)
  
```

Se for necessário adicionar qualquer um dos componentes que fazem parte da base do game no Bonfire(Decorations ou Enemy), deverá ser adicionado com seus métodos específicos:

```dart
this.gameRef.addEnemy(ENEMY);
this.gameRef.addDecoration(DECORATION);
```

### Câmera
É possível movimentar a câmera de forma animada para uma determinada posição do mapa e depois voltar para o personagem. Lembrando que ao movimentar a câmera para uma determinada posição, o player fica bloqueado de ações e movimentos e só é desbloqueado quando a câmera volta a focar nele.

```dart
 gameRef.gameCamera.moveToPosition(Position(X,Y));
 gameRef.gameCamera.moveToPlayer();
 gameRef.gameCamera.moveToPositionAnimated(Position(X,Y));
 gameRef.gameCamera.moveToPlayerAnimated();
```

## Próximos passos
- [ ] Documentação detalhada dos componentes.
- [ ] Support with [Tiled](https://www.mapeditor.org/)
- [ ] Using Box2D

## Game exemplo
[![](https://github.com/RafaelBarbosatec/darkness_dungeon/blob/master/icone/icone_small.png)](https://github.com/RafaelBarbosatec/darkness_dungeon)
