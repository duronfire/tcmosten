# Warning: 
    only Capital case for all class names!!! lower case will not work and give no error message!!!
    Arrow function for assgin object literal must use ({}), i.e. state => ({x:y}), state=>{} will not work!
    infinit loop problem
        render() in react component must be pure without setState. otherwise cause infinit loop.
        setState in function of component must be cased with "if". except event handler, it will cause infinit loop.
    if key is used, key will not be passt as argument. To get key passt, pass both id = xxx with key = xxx to component and retrieve key by id 

# clone object and array
    object using var newobj = {...oldobj}
    array using var newarray = oldarray.slice()

# about bind():

    as example:
    class Toggle extends React.Component {
    constructor(props) {
        super(props);
        this.state = {isToggleOn: true};

        #### This binding is necessary to make `this` work in callback below: onClick={this.handleClick}
        this.handleClick = this.handleClick.bind(this);
    }

    #### handleClick() is a class method, class method is not bound!!! 
    handleClick() {
        this.setState(state => ({ #### "this.setState" would refer to undefined, if not bound. Because "this" is inner a non-bound class method and has not been defined yet. "this" will be then defined, until bind() is used!
        isToggleOn: !state.isToggleOn ####see setstate() in react.component. setState can be used as setState(stateChange[, callback]), in which stateChange is a object  {a:b}. Or setState with setState(updater [, callback]), where updater is a function like (state, props) => stateChange or (state)=>stateChange.
        }));
    }

    render() {
        return (
        <button onClick={this.handleClick}> #### use this.handleClick in constructor. it can be rewritten in <button onClick={(e) => this.handleClick(e)}>Delete Row</button> or <button onClick={this.deleteRow.bind(this)}
            {this.state.isToggleOn ? 'ON' : 'OFF'}
        </button>
        );
    }
    }


# pass argument to events:
    
    
    handleClick(id,event){
        event.preventDefault
        event.target.value
    }

    <button onClick={(e) => this.handleClick(id, e)}
    <button onClick={this.handleClick.bind(this, id)}
    In both cases, the e argument representing the React event will be passed as a **second** argument after the ID. With an arrow function, we have to pass it explicitly, but with bind any further arguments are automatically forwarded.


# setState for shadow merge:
    For example, your state may contain several independent variables:

    constructor(props) {
        super(props);
        this.state = {
        posts: [],
        comments: []
        };
    }
    Then you can update them independently with separate setState() calls:

    componentDidMount() {
        fetchPosts().then(response => {
        this.setState({
            posts: response.posts
        });
        });

        fetchComments().then(response => {
        this.setState({
            comments: response.comments
        });
        });
    }
    The merging is shallow, so this.setState({comments}) leaves this.state.posts intact, but completely replaces this.state.comments.
    !Warning!: only valid for key direct under state. If there is a under structure like {posts: {0: "x", 1: "xx"}, comments: {0: "y", 1: "yy"}}. "0" and "1" with their values will be overwriten by setState({posts: {0: "xxx"}}). Result will be {posts: {0: "xxx"}, comments: {0: "y", 1: "yy"}}  
    TO prevent that problem, reconstruct obj to following {0: {post: "x", comments: "y"}, 1: {post: "xx", comments: "yy"}}  


# setState is delayed!!!!
    setState() does not always immediately update the component. It may batch or defer the update until later. This makes reading this.state right after calling setState() a potential pitfall. Instead, use componentDidUpdate or a setState callback (setState(updater, callback)), either of which are guaranteed to fire after the update has been applied. If you need to set the state based on the previous state, use arrow function to pass call back to setState. All changes will be then just in time!

    this.setState((state, props) => {return {counter: state.counter + props.step}});

